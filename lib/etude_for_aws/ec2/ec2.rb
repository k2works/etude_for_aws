require 'aws-sdk'
require 'dotenv'
require 'base64'
require 'fileutils'

module EC2
  class Configuration
    include CertificationHelper

    attr_reader :client,
                :ec2,
                :vpc_id,
                :subnet_id,
                :az,
                :yaml

    def initialize
      aws_certificate

      @yaml = YAML.load_file('config.yml')

      @client = Aws::EC2::Client.new
      @ec2 = Aws::EC2::Resource.new(client: client)
      @vpc_id = 'vpc-4dc3f22a'
      @subnet_id = 'subnet-cfd598a8'
      @az = 'us-west-2b'
    end
  end

  class SecurityGroup
    attr_accessor :security_group_id

    def initialize(config)
      @config = config
      group_name = @config.yaml['DEV']['EC2']['SECURITY_GROUP_NAME']
      description = @config.yaml['DEV']['EC2']['SECURITY_GROUP_DESCRIPTION']
      vpc_id = @config.vpc_id
      @security_group = {
          group_name: group_name,
          description: description,
          vpc_id: vpc_id,
      }
      @authorize_egress = {
          ip_permissions: [
              {
                  ip_protocol: "tcp",
                  from_port: 22,
                  to_port: 22,
                  ip_ranges: [
                      {
                          cidr_ip: "0.0.0.0/0",
                      },
                  ],
              },
          ],
      }
      @authorize_ingress = {
          ip_permissions: [
              {
                  ip_protocol: "tcp",
                  from_port: 22,
                  to_port: 22,
                  ip_ranges: [
                      {
                          cidr_ip: "0.0.0.0/0",
                      },
                  ],
              },
          ],
      }
    end

    def create
      sg_name = []
      @config.ec2.security_groups.each do |sg|
        sg_name << sg.group_name
      end
      unless sg_name.include?(@security_group[:group_name])
        sg = @config.ec2.create_security_group(@security_group)

        sg.authorize_egress(@authorize_egress)
        sg.authorize_ingress(@authorize_ingress)
        @security_group_id = sg.group_id
      end
    end

    def delete
      resp = nil
      group_id = nil
      @config.ec2.security_groups.each do |sg|
        if sg.group_name == @security_group[:group_name]
          group_id = sg.group_id
        end
      end
      unless group_id.nil?
        resp = @config.client.delete_security_group({
                                                        group_id: group_id,
                                                    })
      end
      resp
    end
  end

  class KeyPair
    attr_reader :key_pair_name,:pem_file

    def initialize(config)
      @config = config
      @key_pair_name = @config.yaml['DEV']['EC2']['KEY_PAIR_NAME']
      path = Dir.pwd + @config.yaml['DEV']['EC2']['KEY_PAIR_PATH']
      @pem_file = path + "#{@key_pair_name}.pem"
    end

    def create
      key_pairs_result = @config.client.describe_key_pairs()
      key_pairs = []
      if key_pairs_result.key_pairs.count > 0
        key_pairs_result.key_pairs.each do |key_pair|
          key_pairs << key_pair.key_name
        end
      end

      unless key_pairs.include?(@key_pair_name)
        begin
          key_pair = @config.client.create_key_pair({
                                                        key_name: @key_pair_name
                                                    })
          puts "Created key pair '#{key_pair.key_name}'."
          puts "\nSHA-1 digest of the DER encoded private key:"
          puts "#{key_pair.key_fingerprint}"
          puts "\nUnencrypted PEM encoded RSA private key:"
          puts "#{key_pair.key_material}"
        rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
          puts "A key pair named '#{@key_pair_name}' already exists."
        end


        File.open(@pem_file, "w") do |file|
          file.puts(key_pair.key_material)
        end
      end
    end

    def delete
      @config.client.delete_key_pair({
                                         key_name: @key_pair_name
                                     })
      FileUtils.rm(@pem_file)
    end
  end

  class Ec2Instance
    def initialize(config)
      @config = config
      script = ''
      @encoded_script = Base64.encode64(script)
      @image_id = @config.yaml['DEV']['EC2']['IMAGE_ID']
      @instance_type = @config.yaml['DEV']['EC2']['INSTANCE_TYPE']
      @min_count = @config.yaml['DEV']['EC2']['MIN_COUNT'].to_i
      @max_count = @config.yaml['DEV']['EC2']['MAX_COUNT'].to_i
      name_value = @config.yaml['DEV']['EC2']['INSTANCE_TAGS']['NAME_VALUE']
      group_value = @config.yaml['DEV']['EC2']['INSTANCE_TAGS']['GROUP_VALUE']
      @instance_tags = [{key: 'Name', value: name_value}, {key: 'Group', value: group_value}]
    end

    def create(security_group,key_pair)
      instance = @config.ec2.create_instances({
                                                  image_id: @image_id,
                                                  min_count: @min_count,
                                                  max_count: @max_count,
                                                  key_name: key_pair.key_pair_name,
                                                  user_data: @encoded_script,
                                                  instance_type: @instance_type,
                                                  placement: {
                                                      availability_zone: @config.az
                                                  },
                                                  network_interfaces: [
                                                      {
                                                          device_index: 0,
                                                          subnet_id: @config.subnet_id,
                                                          associate_public_ip_address: true,
                                                          groups: [security_group.security_group_id],
                                                      },
                                                  ],
                                              })

      @config.ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})

      instance.create_tags({tags: @instance_tags})

      instance
    end

    def terminate
      instance_ids = []
      resp = @config.client.describe_instances(filters: [{name: "tag:Name", values: [@instance_tags[0][:value]]}])
      resp.reservations.each do |reservation|
        reservation.instances.each do |instance|
          instance_ids << instance.instance_id
        end
      end
      instance_ids.each do |instance_id|
        i = @config.ec2.instance(instance_id)

        if i.exists?
          case i.state.code
            when 48 # terminated
              puts "#{instance_id} is already terminated"
            else
              i.terminate
          end
        end

        @config.ec2.client.wait_until(:instance_terminated, {instance_ids: [instance_id]})
      end
    end
  end

  class Ec2
    def initialize
      @config = Configuration.new
      @security_group = SecurityGroup.new(@config)
      @key_pair = KeyPair.new(@config)
      @ec2_instance = Ec2Instance.new(@config)
    end

    def create

      create_security_group

      create_key_pair

      create_ec2_instance

    end

    def destroy

      terminate_ec2_instance

      delete_security_group

      delete_key_pair

    end

    private
    def create_security_group
      @security_group.create
    end

    def create_key_pair
      @key_pair.create
    end

    def create_ec2_instance
      @ec2_instance.create(@security_group,@key_pair)
    end

    def terminate_ec2_instance
      @ec2_instance.terminate
    end

    def delete_security_group
      @security_group.delete
    end

    def delete_key_pair
      @key_pair.delete
    end
  end
end
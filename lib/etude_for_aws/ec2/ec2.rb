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
                :security_group,
                :authorize_egress,
                :authorize_ingress,
                :key_pair_name,
                :pem_file,
                :encoded_script,
                :image_id,
                :subnet_id,
                :az,
                :instance_type,
                :min_count,
                :max_count,
                :instance_tags,
                :tag_name_value

    attr_accessor :security_group_id,
                  :instances

    def initialize
      aws_certificate
      @client = Aws::EC2::Client.new
      @ec2 = Aws::EC2::Resource.new(client: client)
      group_name = 'MyGroovySecurityGroup'
      description = 'Security group for MyGroovyInstance'
      @vpc_id = 'vpc-4dc3f22a'
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

      @key_pair_name = "my-key-pair"
      path = Dir.pwd + '/lib/etude_for_aws/ec2/'
      @pem_file = path + "#{@key_pair_name}.pem"

      script = ''
      @encoded_script = Base64.encode64(script)
      @image_id = 'ami-4836a428'
      @subnet_id = 'subnet-cfd598a8'
      @az = 'us-west-2b'
      @instance_type = 't2.micro'
      @min_count = 1
      @max_count = 1
      @instance_tags = [{key: 'Name', value: 'MyGroovyInstance'}, {key: 'Group', value: 'MyGroovyGroup'}]
      @instances = []

      @tag_name_value = 'MyGroovyInstance'
    end
  end

  class Ec2
    def initialize
      @config = Configuration.new
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
      sg_name = []
      @config.ec2.security_groups.each do |sg|
        sg_name << sg.group_name
      end
      unless sg_name.include?(@config.security_group[:group_name])
        sg = @config.ec2.create_security_group(@config.security_group)

        sg.authorize_egress(@config.authorize_egress)
        sg.authorize_ingress(@config.authorize_ingress)
        @config.security_group_id = sg.group_id
      end
    end

    def create_key_pair
      key_pairs_result = @config.client.describe_key_pairs()
      key_pairs = []
      if key_pairs_result.key_pairs.count > 0
        key_pairs_result.key_pairs.each do |key_pair|
          key_pairs << key_pair.key_name
        end
      end

      unless key_pairs.include?(@config.key_pair_name)
        begin
          key_pair = @config.client.create_key_pair({
                                                key_name: @config.key_pair_name
                                            })
          puts "Created key pair '#{key_pair.key_name}'."
          puts "\nSHA-1 digest of the DER encoded private key:"
          puts "#{key_pair.key_fingerprint}"
          puts "\nUnencrypted PEM encoded RSA private key:"
          puts "#{key_pair.key_material}"
        rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
          puts "A key pair named '#{@config.key_pair_name}' already exists."
        end


        File.open(@config.pem_file, "w") do |file|
          file.puts(key_pair.key_material)
        end
      end
    end

    def create_ec2_instance
      instance = @config.ec2.create_instances({
                                          image_id: @config.image_id,
                                          min_count: @config.min_count,
                                          max_count: @config.max_count,
                                          key_name: @config.key_pair_name,
                                          user_data: @config.encoded_script,
                                          instance_type: @config.instance_type,
                                          placement: {
                                              availability_zone: @config.az
                                          },
                                          network_interfaces: [
                                              {
                                                  device_index: 0,
                                                  subnet_id: @config.subnet_id,
                                                  associate_public_ip_address: true,
                                                  groups: [@config.security_group_id],
                                              },
                                          ],
                                      })

      @config.ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})

      instance.create_tags({tags: @config.instance_tags})

      @config.instances << instance
    end

    def terminate_ec2_instance
      instance_ids = []
      resp = @config.client.describe_instances(filters: [{name: "tag:Name", values: [@config.tag_name_value]}])
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

    def delete_security_group
      group_id = nil
      @config.ec2.security_groups.each do |sg|
        if sg.group_name == @config.security_group[:group_name]
          group_id = sg.group_id
        end
      end
      unless group_id.nil?
        resp = @config.client.delete_security_group({
                                                group_id: group_id,
                                            })
        resp
      end
    end

    def delete_key_pair
      @config.client.delete_key_pair({
                                         key_name: @config.key_pair_name
                                     })
      FileUtils.rm(@config.pem_file)
    end
  end
end
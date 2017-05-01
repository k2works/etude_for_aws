require 'aws-sdk'
require 'dotenv'
require 'base64'
require 'fileutils'

module EC2
  class Ec2
    def self.create
      Dotenv.load
      region = ENV['AWS_DEFAULT_REGION']
      client = Aws::EC2::Client.new(region: region)
      ec2 = Aws::EC2::Resource.new(client: client)
      group_name = 'MyGroovySecurityGroup'
      description = 'Security group for MyGroovyInstance'
      vpc_id = 'vpc-4dc3f22a'
      security_group = {
          group_name: group_name,
          description: description,
          vpc_id: vpc_id
      }
      authorize_egress = {
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
      authorize_ingress = {
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
      sg = create_security_group(authorize_egress,authorize_ingress, ec2, group_name, security_group)

      key_pair_name = "my-key-pair"
      create_key_pair(client, key_pair_name)

      script = ''
      encoded_script = Base64.encode64(script)
      image_id = 'ami-4836a428'
      sg_group_id = sg.group_id
      subnet_id = 'subnet-cfd598a8'
      az = 'us-west-2b'
      instance_type = 't2.micro'
      min_count = 1
      max_count = 1
      instance_tags = [{key: 'Name', value: 'MyGroovyInstance'}, {key: 'Group', value: 'MyGroovyGroup'}]
      create_ec2_instancde(az, ec2, encoded_script, image_id, instance_tags, instance_type, key_pair_name, max_count, min_count, sg_group_id, subnet_id)
    end

    def self.destroy
      Dotenv.load
      client = Aws::EC2::Client.new(region: ENV['AWS_DEFAULT_REGION'])
      ec2 = Aws::EC2::Resource.new(client: client)

      # Terminating an Instance
      tag_name_value = 'MyGroovyInstance'
      instance_ids = []
      resp = client.describe_instances(filters:[{ name: "tag:Name", values: [tag_name_value] }])
      resp.reservations.each do |reservation|
        reservation.instances.each do |instance|
          instance_ids << instance.instance_id
        end
      end
      instance_ids.each do |instance_id|
        i = ec2.instance(instance_id)

        if i.exists?
          case i.state.code
            when 48  # terminated
              puts "#{instance_id} is already terminated"
            else
              i.terminate
          end
        end

        # Wait for the instance to be created, running, and passed status checks
        ec2.client.wait_until(:instance_terminated, {instance_ids: [instance_id]})
      end

      group_name = 'MyGroovySecurityGroup'
      group_id = nil
      ec2.security_groups.each do |sg|
        if sg.group_name == group_name
          group_id = sg.group_id
        end
      end
      unless group_id.nil?
        resp = client.delete_security_group({
                                                group_id: group_id,
                                            })
        resp
      end

      key_pair_name = "my-key-pair"

      # Delete the key pair.
      client.delete_key_pair({
                              key_name: key_pair_name
                          })

      path = Dir.pwd + '/lib/etude_for_aws/ec2/'
      pem_file = path + "#{key_pair_name}.pem"
      FileUtils.rm(pem_file)
    end

    private
    def self.create_security_group(authorize_egress, authorize_ingress, ec2, group_name, security_group)
      sg_name = []
      ec2.security_groups.each do |sg|
        sg_name << sg.group_name
      end
      unless sg_name.include?(group_name)
        sg = ec2.create_security_group(security_group)

        sg.authorize_egress(authorize_egress)
        sg.authorize_ingress(authorize_ingress)
        sg
      end
    end

    def self.create_key_pair(client, key_pair_name)
      key_pairs_result = client.describe_key_pairs()
      key_pairs = []
      if key_pairs_result.key_pairs.count > 0
        key_pairs_result.key_pairs.each do |key_pair|
          key_pairs << key_pair.key_name
        end
      end

      unless key_pairs.include?(key_pair_name)
        begin
          key_pair = client.create_key_pair({
                                                key_name: key_pair_name
                                            })
          puts "Created key pair '#{key_pair.key_name}'."
          puts "\nSHA-1 digest of the DER encoded private key:"
          puts "#{key_pair.key_fingerprint}"
          puts "\nUnencrypted PEM encoded RSA private key:"
          puts "#{key_pair.key_material}"
        rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
          puts "A key pair named '#{key_pair_name}' already exists."
        end

        path = Dir.pwd + '/lib/etude_for_aws/ec2/'
        pem_file = path + "#{key_pair_name}.pem"
        File.open(pem_file, "w") do |file|
          file.puts(key_pair.key_material)
        end
      end
    end

    def self.create_ec2_instancde(az, ec2, encoded_script, image_id, instance_tags, instance_type, key_pair_name, max_count, min_count, sg_group_id, subnet_id)
      instance = ec2.create_instances({
                                          image_id: image_id,
                                          min_count: min_count,
                                          max_count: max_count,
                                          key_name: key_pair_name,
                                          user_data: encoded_script,
                                          instance_type: instance_type,
                                          placement: {
                                              availability_zone: az
                                          },
                                          network_interfaces: [
                                              {
                                                  device_index: 0,
                                                  subnet_id: subnet_id,
                                                  associate_public_ip_address: true,
                                                  groups: [sg_group_id],
                                              },
                                          ],
                                      })

      # Wait for the instance to be created, running, and passed status checks
      ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})

      # Name the instance 'MyGroovyInstance' and give it the Group tag 'MyGroovyGroup'
      instance.create_tags({tags: instance_tags})

      instance
    end
  end
end
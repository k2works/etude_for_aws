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
      sg_name = []
      ec2.security_groups.each do |sg|
        sg_name << sg.group_name
      end
      unless sg_name.include?(group_name)
        sg = ec2.create_security_group({
                                           group_name: group_name,
                                           description: description,
                                           vpc_id: vpc_id
                                       })

        sg.authorize_egress({
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
                            })
        sg
      end

      key_pair_name = "my-key-pair"

      # Get information about Amazon EC2 key pairs.
      key_pairs_result = client.describe_key_pairs()

      key_pairs = []
      if key_pairs_result.key_pairs.count > 0
        key_pairs_result.key_pairs.each do |key_pair|
          key_pairs << key_pair.key_name
        end
      end

     # Create a key pair.
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
        File.open(pem_file,"w") do |file|
          file.puts(key_pair.key_material)
        end
      end

      # Create EC2 Instance
      # User code that's executed when the instance starts
      script = ''
      encoded_script = Base64.encode64(script)
      image_id = 'ami-4836a428'
      sg_group_id = 'sg-c2c944b9'
      subnet_id = 'subnet-cfd598a8'
      az = 'us-west-2b'
      instance = ec2.create_instances({
                                          image_id: image_id,
                                          min_count: 1,
                                          max_count: 1,
                                          key_name: key_pair_name,
                                          security_group_ids: [sg_group_id],
                                          user_data: encoded_script,
                                          instance_type: 't2.micro',
                                          placement: {
                                              availability_zone: az
                                          },
                                          subnet_id: subnet_id,
                                      })

      # Wait for the instance to be created, running, and passed status checks
      ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})

      # Name the instance 'MyGroovyInstance' and give it the Group tag 'MyGroovyGroup'
      instance.create_tags({ tags: [{ key: 'Name', value: 'MyGroovyInstance' }, { key: 'Group', value: 'MyGroovyGroup' }]})

      puts instance.id
    end

    def self.destroy
      Dotenv.load
      client = Aws::EC2::Client.new(region: ENV['AWS_DEFAULT_REGION'])
      ec2 = Aws::EC2::Resource.new(client: client)

      # Terminating an Instance
      instance_id = 'i-0c6b7033a4420dc0e'
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
  end
end
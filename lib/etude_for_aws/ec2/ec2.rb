require 'aws-sdk'
require 'dotenv'
require 'base64'
require 'fileutils'

module EC2
  class Ec2
    def initialize(vpc)
      @config = Configuration.new
      @config.vpc_id = vpc.get_vpc_id
      @subnet_infos = vpc.get_subnet_infos
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

    def start
      instance_ids = @ec2_instance.get_instance_collection
      instance_ids.each do |instance_id|
        i = @config.ec2.instance(instance_id)

        if i.exists?
          case i.state.code
            when 0  # pending
              puts "#{instance_id} is pending, so it will be running in a bit"
            when 16  # started
              puts "#{instance_id} is already started"
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot start it"
            else
              puts "#{instance_id} is starting"
              i.start
              @config.ec2.client.wait_until(:instance_running, {instance_ids: [instance_id]})
          end
        end
      end
    end

    def stop
      instance_ids = @ec2_instance.get_instance_collection
      instance_ids.each do |instance_id|
        i = @config.ec2.instance(instance_id)

        if i.exists?
          case i.state.code
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot stop it"
            when 64  # stopping
              puts "#{instance_id} is stopping, so it will be stopped in a bit"
            when 89  # stopped
              puts "#{instance_id} is already stopped"
            else
              puts "#{instance_id} is stopping"
              i.stop
              @config.ec2.client.wait_until(:instance_stopped, {instance_ids: [instance_id]})
          end
        end
      end
    end

    def reboot
      instance_ids = @ec2_instance.get_instance_collection
      instance_ids.each do |instance_id|
        i = @config.ec2.instance(instance_id)

        if i.exists?
          case i.state.code
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot reboot it"
            else
              puts "#{instance_id} is rebooting"
              i.reboot
              @config.ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance_id]})
          end
        end
      end
    end

    private
    def create_security_group
      @security_group.create
    end

    def create_key_pair
      @key_pair.create
    end

    def create_ec2_instance
      @subnet_infos.each do |info|
        @config.subnet_id = info[:subnet_id]
        @config.az = info[:az]
        @ec2_instance.create(@security_group,@key_pair)
      end
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

  class Ec2Stub < Ec2
    def start
      p "#{self.class} start instances"
    end

    def reboot
      p "#{self.class} reboot instances"
    end

    def stop
      p "#{self.class} stop instances"
    end

    private
    def create_security_group
      p "#{self.class} Create Security Group"
    end

    def create_key_pair
      p "#{self.class} Create key pair"
    end

    def create_ec2_instance
      @subnet_infos.each do |info|
        p "#{self.class} Create EC2 Instance in Subnet #{info[:subnet_id]}"
      end
    end

    def terminate_ec2_instance
      p "#{self.class} Terminate EC2 Instance"
    end

    def delete_security_group
      p "#{self.class} Delete Security Group"
    end

    def delete_key_pair
      p "#{self.class} Delete key pair"
    end
  end
end
require 'aws-sdk'
require 'dotenv'
require 'base64'
require 'fileutils'

module EC2
  class Ec2
    attr_reader :config,:gateway,:security_group,:key_pair,:ec2_instance

    def initialize(vpc)
      @config = Configuration.new
      @gateway = Ec2ApiGateway.new
      @config.vpc_id = vpc.get_vpc_id
      @subnet_infos = vpc.get_subnet_infos
      @security_group = SecurityGroup.new(self)
      @key_pair = KeyPair.new(self)
      @ec2_instance = Ec2Instance.new(self)
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
        i = @gateway.resource.instance(instance_id)

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
              @gateway.resource.client.wait_until(:instance_running, {instance_ids: [instance_id]})  unless @config.stub?
          end
        end
      end
    end

    def stop
      instance_ids = @ec2_instance.get_instance_collection
      instance_ids.each do |instance_id|
        i = @gateway.resource.instance(instance_id)

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
              @gateway.resource.client.wait_until(:instance_stopped, {instance_ids: [instance_id]}) unless @config.stub?
          end
        end
      end
    end

    def reboot
      instance_ids = @ec2_instance.get_instance_collection
      instance_ids.each do |instance_id|
        i = @gateway.resource.instance(instance_id)

        if i.exists?
          case i.state.code
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot reboot it"
            else
              puts "#{instance_id} is rebooting"
              i.reboot
              @gateway.client.wait_until(:instance_status_ok, {instance_ids: [instance_id]})  unless @config.stub?
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
      @ec2_instance = nil if @ec2_instance.terminate.empty?
    end

    def delete_security_group
      @security_group = nil if @security_group.delete.nil?
    end

    def delete_key_pair
      @key_pair.delete
      @key_pair = nil
    end
  end

  class Ec2Stub < Ec2
    def initialize(vpc)
      @config = ConfigurationStub.new
      @gateway = Ec2ApiGatewayStub.new
      @config.vpc_id = vpc.get_vpc_id
      @subnet_infos = vpc.get_subnet_infos
      @security_group = SecurityGroup.new(self)
      @key_pair = KeyPair.new(self)
      @ec2_instance = Ec2Instance.new(self)
    end

    def start
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: 'String',
                                                     state: {'code':89}
                                                 ]
                                             }
                                         ]
                                     })
      super
    end

    def reboot
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: 'String',
                                                     state: {'code':16}
                                                 ]
                                             }
                                         ]
                                     })
      super
    end

    def stop
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: 'String',
                                                     state: {'code':16}
                                                 ]
                                             }
                                         ]
                                     })
      super
    end

    private
    def create_security_group
      super
    end

    def create_key_pair
      super
    end

    def create_ec2_instance
      super
    end

    def terminate_ec2_instance
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: 'String',
                                                     state: {'code':16}
                                                 ]
                                             }
                                         ]
                                     })
      super
      @ec2_instance = nil
    end

    def delete_security_group
      super
      @security_group = nil
    end

    def delete_key_pair
      super
    end
  end
end
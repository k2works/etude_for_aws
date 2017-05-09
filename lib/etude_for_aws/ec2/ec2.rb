module EC2
  class Ec2
    attr_reader :config,:gateway,:security_group,:key_pair,:ec2_instances

    def initialize(vpc)
      @config = Configuration.new
      @gateway = Ec2ApiGateway.new
      setup_config(vpc)
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
      @ec2_instances.each do |ec2_instance|
        ec2_instance.start
      end
    end

    def stop
      @ec2_instances.each do |ec2_instance|
        ec2_instance.stop
      end
    end

    def reboot
      @ec2_instances.each do |ec2_instance|
        ec2_instance.reboot
      end
    end

    private
    def setup_config(vpc)
      @config.vpc_id = vpc.get_vpc_id
      @subnet_infos = vpc.get_subnet_infos
      @security_group = SecurityGroup.new(self)
      @key_pair = KeyPair.new(self)

      @ec2_instances = []
      @config.instance_tags_public.each do |tag|
        @config.instance_tags = tag
        values = [@config.instance_tags[0][:value]]
        instance_ids = @gateway.get_instance_collection(values)
        instance_ids.each do |instance_id|
          ec2_instance = Ec2Instance.new(self, instance_id)
          @ec2_instances << ec2_instance
        end
      end

      @config.instance_tags_private.each do |tag|
        @config.instance_tags = tag
        values = [@config.instance_tags[0][:value]]
        instance_ids = @gateway.get_instance_collection(values)
        instance_ids.each do |instance_id|
          ec2_instance = Ec2Instance.new(self, instance_id)
          @ec2_instances << ec2_instance
        end
      end
    end

    def create_security_group
      @security_group.create
    end

    def create_key_pair
      @key_pair.create
    end

    def create_ec2_instance
      private_i = 0
      public_i = 0
      @subnet_infos.each do |info|
        @config.subnet_id = info[:subnet_id]
        @config.az = info[:az]
        if info[:network] == 'Private'
          @config.instance_tags = @config.instance_tags_private[private_i]
          private_i += private_i
        else
          @config.instance_tags = @config.instance_tags_public[public_i]
          public_i += public_i
        end
        ec2_instance = Ec2Instance.new(self)
        ec2_instance.create(@security_group,@key_pair)
        @ec2_instances << ec2_instance
      end
    end

    def terminate_ec2_instance
      @ec2_instances.each do |ec2_instance|
        ec2_instance.terminate
      end
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
      setup_config(vpc)
    end

    def start
      instance_id = 'String'
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: instance_id,
                                                     state: {'code':89}
                                                 ]
                                             }
                                         ]
                                     })
      @ec2_instances << Ec2Instance.new(self, instance_id)
      super
    end

    def reboot
      instance_id = 'String'
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: instance_id,
                                                     state: {'code':16}
                                                 ]
                                             }
                                         ]
                                     })
      @ec2_instances << Ec2Instance.new(self, instance_id)
      super
    end

    def stop
      instance_id = 'String'
      @gateway.client.stub_responses(:describe_instances,
                                     {
                                         reservations: [
                                             {
                                                 instances: [
                                                     instance_id: instance_id,
                                                     state: {'code':16}
                                                 ]
                                             }
                                         ]
                                     })
      @ec2_instances << Ec2Instance.new(self, instance_id)
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
      @ec2_instances.first.instance_variable_set :@instance_id,'String' unless @ec2_instances.first.nil?
      super
      @ec2_instances = []
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
module CFM
  class OneAzOnePublicSubnetVpc < Vpc
    def initialize
      super
      template_file = @config.get_template_file(CFM::Vpc::TYPE.fetch(1))
      file = get_template_full_path(template_file)
      @config.template = File.read(file)
      @config.parameters = [
          {
              parameter_key: "AZ1",
              parameter_value: @config.azs[0],
              use_previous_value: false,
          },
      ]
    end

    def get_subnet_info(logical_resource_id)
      info = {}
      info[:subnet_id] = @cfm.describe_stack_resource({stack_name: @config.stack_name, logical_resource_id: logical_resource_id}).stack_resource_detail.physical_resource_id
      info[:az] = @config.azs[0]
      info
    end

    def get_subnet_infos
      infos = []
      infos << get_subnet_info('Subnet')
      infos
    end
  end

  class OneAzOnePublicSubnetVpcStub < VpcStub
    def get_subnet_info
      info = {}
      info[:subnet_id] = 'DUMMY_SUBNET_ID'
      info[:az] = 'DUMMY_AZ'
      info
    end

    def get_subnet_infos
      infos = []
      infos << get_subnet_info
      infos
    end
  end
end
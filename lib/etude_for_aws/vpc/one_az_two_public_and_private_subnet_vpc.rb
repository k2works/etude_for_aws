module VPC
  class OneAzTwoPublicAndPrivateSubnetVpc < Vpc
    def initialize
      super
      template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_03']
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
      infos << get_subnet_info('PublicSubnet')
      infos << get_subnet_info('PrivateSubnet')
      infos
    end
  end

  class OneAzTwoPublicAndPrivateSubnetVpcStub < VpcStub; end
end
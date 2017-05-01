module VPC
  class OneAzOnePublicSubnetVpc < Vpc
    def initialize
      super
      template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_01']
      file = get_template_full_path(template_file)
      @config.template = File.read(file)
      @config.parameters = []
    end

    def get_subnet_info
      info = {}
      info[:subnet_id] = @cfm.describe_stack_resource({stack_name: @config.stack_name, logical_resource_id: 'Subnet'}).stack_resource_detail.physical_resource_id
      info[:az] = @config.azs[1]
      info
    end
  end
end
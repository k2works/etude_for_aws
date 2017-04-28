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
  end
end
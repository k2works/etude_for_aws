module CFM
  class TwoAzTwoPublicSubnetVpc < Vpc
    def initialize
      super
      template_file = @config.yaml['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_05']
      file = get_template_full_path(template_file)
      @config.template = File.read(file)
      @config.parameters = [
          {
              parameter_key: "AZ1",
              parameter_value: @config.azs[0],
              use_previous_value: false,
          },
          {
              parameter_key: "AZ2",
              parameter_value: @config.azs[1],
              use_previous_value: false,
          },
      ]
    end
  end

  class TwoAzTwoPublicSubnetVpcStub < VpcStub
    def get_subnet_info
      info = {}
      info[:subnet_id] = 'DUMMY_SUBNET_ID'
      info[:az] = 'DUMMY_AZ'
      info
    end

    def get_subnet_infos
      infos = []
      infos << get_subnet_info
      infos << get_subnet_info
      infos
    end
  end
end
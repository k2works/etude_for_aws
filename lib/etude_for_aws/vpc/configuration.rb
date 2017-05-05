module VPC
  class Configuration
    include CertificationHelper
    include ConfigurationHelper

    attr_reader :vpc_name,
                :vpc_cidr_block,
                :subnet_cidr_block,
                :destination_cidr_block,
                :tags,
                :filter_tag_value,
                :ec2

    def initialize
      aws_certificate

      @vpc_name = get_yaml_vpc_name
      @vpc_cidr_block = get_yaml_vpc_cidr_block
      @subnet_cidr_block = get_yaml_subnet_cidr_block
      @destination_cidr_block = get_yaml_destination_cidr_block
      @tags = [{key: 'Name', value: @vpc_name}]
      @filter_tag_value = {name: 'tag-value', values: [@vpc_name]}
    end
  end

  class ConfigurationStub < Configuration
    def initialize
      super
      @ec2 = Aws::EC2::Client.new(stub_responses: true)
    end
  end
end

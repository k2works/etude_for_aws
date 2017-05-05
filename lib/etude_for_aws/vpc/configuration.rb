module VPC
  class Configuration
    include ConfigurationHelper

    attr_reader :vpc_name,
                :vpc_cidr_block,
                :subnet_cidr_block,
                :destination_cidr_block,
                :tags,
                :filter_tag_value

    def initialize
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
    end
  end
end

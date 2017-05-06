module VPC
  class Configuration
    include ConfigurationHelper

    attr_reader :vpc_name,
                :vpc_cidr_block,
                :subnet_cidr_block,
                :subnet_cidr_block_public,
                :subnet_cidr_block_private,
                :destination_cidr_block,
                :vpc_name_tag,
                :vpc_group_tag,
                :tags,
                :filter_tag_value

    def initialize
      vpc_tags = get_yaml_vpc_tags
      @vpc_name = vpc_tags['NAME']['Value']
      @vpc_group_name = vpc_tags['GROUP']['Value']
      @vpc_cidr_block = get_yaml_vpc_cidr_block
      @subnet_cidr_block = get_yaml_subnet_cidr_block
      @subnet_cidr_block_public = get_yaml_subnet_cidr_block_public
      @subnet_cidr_block_private = get_yaml_subnet_cidr_block_private
      @destination_cidr_block = get_yaml_destination_cidr_block

      @vpc_name_tag = {key: vpc_tags['NAME']['Key'], value: @vpc_name}
      @vpc_group_tag = {key: vpc_tags['GROUP']['Key'], value: @vpc_group_name}
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

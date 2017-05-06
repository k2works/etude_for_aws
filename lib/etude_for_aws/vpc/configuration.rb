module VPC
  class Configuration
    include ConfigurationHelper

    attr_reader :vpc_name,
                :vpc_cidr_block,
                :subnet_names,
                :route_table_names,
                :public_subnets,
                :private_subnets,
                :public_route_tables,
                :private_route_tables,
                :internet_gateway,
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
      @vpc_name = vpc_tags['NAME']['VALUE']
      @vpc_group_name = vpc_tags['GROUP']['VALUE']
      @vpc_cidr_block = get_yaml_vpc_cidr_block

      vpc_subnets = get_yaml_vpc_subnets
      @subnet_names = []
      vpc_subnets['PUBLIC'].each do |v|
        @subnet_names << v['CONFIG']['SUBNET_TAGS'].first['NAME']['VALUE']
      end
      vpc_subnets['PRIVATE'].each do |v|
        @subnet_names << v['CONFIG']['SUBNET_TAGS'].first['NAME']['VALUE']
      end
      @public_subnets = vpc_subnets['PUBLIC']
      @private_subnets = vpc_subnets['PRIVATE']

      vpc_route_tables = get_yaml_vpc_route_tables
      @route_table_names = []
      vpc_route_tables['PUBLIC'].each do |v|
        @route_table_names << v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
      end
      vpc_route_tables['PRIVATE'].each do |v|
        @route_table_names << v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
      end
      @public_route_tables = vpc_route_tables['PUBLIC']
      @private_route_tables = vpc_route_tables['PRIVATE']

      @internet_gateway = get_yaml_internet_gateway

#      @subnet_cidr_block = vpc_subnets['PUBLIC']['SUBNET_CIDR_BLOCK'][0]
#      @subnet_cidr_block_public = vpc_subnets['PUBLIC']['SUBNET_CIDR_BLOCK'][0]
#      @subnet_cidr_block_private = vpc_subnets['PRIVATE']['SUBNET_CIDR_BLOCK'][0]
#      @destination_cidr_block = get_yaml_destination_cidr_block

      @vpc_name_tag = {key: vpc_tags['NAME']['KEY'], value: @vpc_name}
      @vpc_group_tag = {key: vpc_tags['GROUP']['KEY'], value: @vpc_group_name}
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

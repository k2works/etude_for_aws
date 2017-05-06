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
                :vpc_name_tag,
                :vpc_group_tag

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

      @vpc_name_tag = {key: vpc_tags['NAME']['KEY'], value: @vpc_name}
      @vpc_group_tag = {key: vpc_tags['GROUP']['KEY'], value: @vpc_group_name}
    end
  end

  class ConfigurationStub < Configuration
    def initialize
      super
    end
  end
end

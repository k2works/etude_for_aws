module VPC
  class SimpleVpc < Vpc
    def initialize
      super
    end

    def create_subnets
      @config.public_subnets.each do |v|
        subnet_cidr_block = v['CONFIG']['SUBNET_CIDR_BLOCK'].first
        name = v['CONFIG']['SUBNET_TAGS'].first['NAME']['VALUE']
        key = v['CONFIG']['SUBNET_TAGS'].first['NAME']['KEY']
        subnets = @gateway.select_subnets_by_name(name)
        if subnets.empty?
          subnet = VPC::Subnet.new
          subnet.create(self,subnet_cidr_block)
          resources = [subnet.subnet_id]
          vpc_subnet_name_tag = {key: key, value: name}
          tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
          @gateway.create_tags(resources,tags)
          @public_subnets << subnet
        end
      end
    end

    def create_route_table
      @public_subnets.each do |subnet|
        @config.public_route_tables.each do |v|
          destination_cidr_block = v['CONFIG']['DESTINATION_CIDR_BLOCK'].first
          name = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
          key = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['KEY']
          route_tables = @gateway.select_route_tables_by_name(name)
          if route_tables.empty?
            route_table = VPC::RouteTable.new
            route_table.create(self)
            route_table.create_public_route(self,destination_cidr_block,@internet_gateway.internet_gateway_id)
            route_table.associate_route_table(self,route_table.route_table_id,subnet.subnet_id)

            resources = [route_table.route_table_id]
            vpc_subnet_name_tag = {key: key, value: name}
            tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
            @gateway.create_tags(resources,tags)
            @public_route_tables << route_table
          end
        end
      end
    end
  end

  class SimpleVpcStub < SimpleVpc
    def initialize
      super
      @config = VPC::ConfigurationStub.new
      @gateway = VPC::VpcApiGatewayStub.new
    end
  end
end

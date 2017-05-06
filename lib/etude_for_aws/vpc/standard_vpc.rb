module VPC
  class StandardVpc < Vpc
    attr_reader :vpc_id,
                :subnet_id,
                :private_subnet_id,
                :public_subnet_id,
                :internet_gateway_id,
                :route_table_id,
                :private_route_table_id,
                :public_route_table_id

    attr_accessor :subnets,
                  :private_subnets,
                  :public_subnets,
                  :internet_gateway,
                  :route_tables,
                  :private_route_tables,
                  :public_route_tables

    def initialize
      super
      @gateway.select_vpcs_by_name(@config.vpc_name).each do |vpc|
        @vpc_id = vpc.vpc_id
      end

      @subnets = []
      @private_subnets = []
      @public_subnets = []
      @config.subnet_names.each do |name|
        @gateway.select_subnets_by_name(name).each do |subnet|
          @subnet_id = subnet.subnet_id
          @subnets << VPC::Subnet.new(self)
        end
      end

      name = @config.internet_gateway['IG_TAGS']['NAME']['VALUE']
      @gateway.select_internet_gateways_by_name(name).each do |internet_gateway|
        @internet_gateway_id = internet_gateway.internet_gateway_id
        @internet_gateway = VPC::InternetGateway.new(self)
      end

      @route_tables = []
      @private_route_tables = []
      @public_route_tables = []
      @config.route_table_names.each do |name|
        @gateway.select_route_tables_by_name(name).each do |route_table|
          @route_table_id = route_table.route_table_id
          @route_tables << VPC::RouteTable.new(self)
        end
      end
    end

    def create_subnets
      @config.public_subnets.each do |v|
        subnet_cidr_block = v['CONFIG']['SUBNET_CIDR_BLOCK'].first
        name = v['CONFIG']['SUBNET_TAGS'].first['NAME']['VALUE']
        key = v['CONFIG']['SUBNET_TAGS'].first['NAME']['KEY']
        subnets = @gateway.select_subnets_by_name(name)
        if subnets.empty?
          subnet = VPC::Subnet.new(self)
          subnet.create(self,subnet_cidr_block)
          resources = [subnet.subnet_id]
          vpc_subnet_name_tag = {key: key, value: name}
          tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
          @gateway.create_tags(resources,tags)
          @public_subnets << subnet
        end
      end

      @config.private_subnets.each do |v|
        subnet_cidr_block = v['CONFIG']['SUBNET_CIDR_BLOCK'].first
        name = v['CONFIG']['SUBNET_TAGS'].first['NAME']['VALUE']
        key = v['CONFIG']['SUBNET_TAGS'].first['NAME']['KEY']
        subnets = @gateway.select_subnets_by_name(name)
        if subnets.empty?
          subnet = VPC::Subnet.new(self)
          subnet.create(self,subnet_cidr_block)
          resources = [subnet.subnet_id]
          vpc_subnet_name_tag = {key: key, value: name}
          tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
          @gateway.create_tags(resources,tags)
          @private_subnets << subnet
        end
      end
    end

    def delete_subnets
      super
      @private_subnets = []
      @public_subnets = []
    end

    def create_route_table
      @public_subnets.each do |subnet|
        @config.public_route_tables.each do |v|
          destination_cidr_block = v['CONFIG']['DESTINATION_CIDR_BLOCK'].first
          name = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
          key = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['KEY']
          route_tables = @gateway.select_route_tables_by_name(name)
          if route_tables.empty?
            route_table = VPC::RouteTable.new(self)
            route_table.create(self)
            route_table.create_public_route(self,destination_cidr_block,@internet_gateway.internet_gateway_id)
            route_table.associate_route_table(self,route_table.route_table_id,subnet.subnet_id)

            resources = [route_table.route_table_id]
            vpc_subnet_name_tag = {key: key, value: name}
            tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
            @gateway.create_tags(resources,tags)
            @route_tables << route_table
          end
        end
      end

      @private_subnets.each do |subnet|
        @config.private_route_tables.each do |v|
          destination_cidr_block = v['CONFIG']['DESTINATION_CIDR_BLOCK'].first
          name = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
          key = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['KEY']
          route_tables = @gateway.select_route_tables_by_name(name)
          if route_tables.empty?
            route_table = VPC::RouteTable.new(self)
            route_table.create(self)
            route_table.associate_route_table(self,route_table.route_table_id,subnet.subnet_id)

            resources = [route_table.route_table_id]
            vpc_subnet_name_tag = {key: key, value: name}
            tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
            @gateway.create_tags(resources,tags)
            @route_tables << route_table
          end
        end
      end
    end

    def delete_route_tables
      super
      @private_route_tables = []
      @public_route_tables = []
    end

  end

  class StandardVpcStub < StandardVpc
    def initialize
      super
      @config = VPC::ConfigurationStub.new
      @gateway = VPC::VpcApiGatewayStub.new
    end
  end
end

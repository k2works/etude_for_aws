module VPC
  class Vpc
    include EC2::VpcInterface

    attr_reader :config,
                :gateway

    attr_accessor :public_subnets,
                  :private_subnets,
                  :public_route_tables,
                  :private_route_tables

    def initialize
      @config = VPC::Configuration.new
      @gateway = VPC::VpcApiGateway.new

      @public_subnets = []
      @private_subnets = []
      @public_route_tables = []
      @private_route_tables = []
    end

    def create_vpc
      if @gateway.select_vpcs_by_name(@config.vpc_name).empty?
        @vpc_id = @gateway.create_vpc(@config.vpc_name,@config.vpc_cidr_block)
        resources = [@vpc_id]
        tags = [@config.vpc_name_tag,@config.vpc_group_tag]
        @gateway.create_tags(resources,tags)
      end
    end

    def delete_vpc
      @gateway.delete_vpc(@vpc_id) unless @vpc_id.nil?
      @vpc_id = nil
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
    end

    def delete_subnets
      @subnets.each do |subnet|
        subnet.delete(self)
      end
      @subnets = []
    end

    def create_internet_gateway
      internet_gateways = @gateway.select_internet_gateways_by_name(@config.vpc_name)
      if internet_gateways.empty?
        @internet_gateway = VPC::InternetGateway.new(self)
        @config.internet_gateway
        key = @config.internet_gateway['IG_TAGS']['NAME']['KEY']
        name = @config.internet_gateway['IG_TAGS']['NAME']['VALUE']
        resources = [@internet_gateway.internet_gateway_id]
        vpc_subnet_name_tag = {key: key, value: name}
        tags = [vpc_subnet_name_tag,@config.vpc_group_tag]
        @gateway.create_tags(resources,tags)
      end
    end

    def delete_internet_gateway
      @internet_gateway.delete(self) unless @internet_gateway.nil?
      @internet_gateway = nil
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
            @public_route_tables << route_table
          end
        end
      end
    end

    def delete_route_tables
      @route_tables.each do |route_table|
        route_table.delete(self)
      end
      @route_tables = []
    end

  end

  class VpcStub < Vpc
    def initialize
      super
      @config = VPC::ConfigurationStub.new
      @gateway = VPC::VpcApiGatewayStub.new
    end
  end
end

module VPC
  class Vpc
    include EC2::VpcInterface

    attr_reader :config,
                :gateway,
                :vpc_id,
                :vpn

    attr_accessor :subnets,
                  :public_subnets,
                  :private_subnets,
                  :public_route_tables,
                  :private_route_tables,
                  :route_tables,
                  :internet_gateway

    def initialize
      @config = VPC::Configuration.new
      @gateway = VPC::VpcApiGateway.new
      @vpn = VPC::Vpn.new

      @public_subnets = []
      @private_subnets = []
      @public_route_tables = []
      @private_route_tables = []

      @gateway.select_vpcs_by_name(@config.vpc_name).each do |vpc|
        @vpc_id = vpc.vpc_id
      end

      @subnets = []
      @config.subnet_names.each do |name|
        @gateway.select_subnets_by_name(name).each do |v|
          subnet = VPC::Subnet.new
          subnet.subnet_id = v.subnet_id
          @subnets << subnet
        end
      end

      name = @config.internet_gateway['IG_TAGS']['NAME']['VALUE']
      @gateway.select_internet_gateways_by_name(name).each do |v|
        @internet_gateway = VPC::InternetGateway.new
        @internet_gateway.internet_gateway_id = v.internet_gateway_id
      end

      @route_tables = []
      @config.route_table_names.each do |name|
        @gateway.select_route_tables_by_name(name).each do |v|
          route_table = VPC::RouteTable.new
          route_table.setup(v.route_table_id,self)
          @route_tables << route_table
        end
      end
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
    end

    def delete_subnets
      @subnets.each do |subnet|
        subnet.delete(self)
      end
      @subnets = []
      @private_subnets = []
      @public_subnets = []
    end

    def create_internet_gateway
      internet_gateways = @gateway.select_internet_gateways_by_name(@config.vpc_name)
      if internet_gateways.empty?
        @internet_gateway = VPC::InternetGateway.new
        @internet_gateway.create(self)
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
    end

    def delete_route_tables
      @route_tables.each do |route_table|
        route_table.delete(self)
      end
      @route_tables = []
      @private_route_tables = []
      @public_route_tables = []
    end

    def create_customer_gateway
      @vpn.create_customer_gateway
    end

    def create_virtual_gateway
      @vpn.create_virtual_gateway
    end

    def create_vpn_connection
      @vpn.create_vpn_connection
    end

    def create_route
      @vpn.create_route
    end

    def delete_customer_gateway
      @vpn.delete_customer_gateway
    end

    def delete_virtual_gateway
      @vpn.delete_virtual_gateway
    end

    def delete_vpn_connection
      @vpn.delete_vpn_connection
    end

    def delete_route
      @vpn.delete_route
    end

    def get_vpc_id
      @vpc_id
    end

    def get_subnet_infos
      infos = []

      @public_subnets.each do |public|
        info = {}
        info[:subnet_id] = public.subnet_id
        info[:network] = 'Public'
        info[:az] = 'us-west-2a'
        infos << info
      end

      @private_subnets.each do |private|
        info = {}
        info[:subnet_id] = private.subnet_id
        info[:network] = 'Private'
        info[:az] = 'us-west-2a'
        infos << info
      end

      infos
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

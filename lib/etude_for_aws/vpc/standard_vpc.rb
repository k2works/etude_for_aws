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
      @gateway.select_subnets_by_name(@config.vpc_name).each do |subnet|
        @subnet_id = subnet.subnet_id
        @subnets << VPC::Subnet.new(self)
      end

      @gateway.select_internet_gateways_by_name(@config.vpc_name).each do |internet_gateway|
        @internet_gateway_id = internet_gateway.internet_gateway_id
        @internet_gateway = VPC::InternetGateway.new(self)
      end

      @route_tables = []
      @private_route_tables = []
      @public_route_tables = []
      @gateway.select_route_tables_by_name(@config.vpc_name).each do |route_table|
        @route_table_id = route_table.route_table_id
        @route_tables << VPC::RouteTable.new(self)
      end
    end

    def create_subnets
      subnets = @gateway.select_subnets_by_name(@config.vpc_name)
      if subnets.empty?
        private_subnet = VPC::Subnet.new(self)
        private_subnet.create_private(self)
        @private_subnet_id = private_subnet.subnet_id
        @private_subnets << private_subnet
        public_subnet = VPC::Subnet.new(self)
        public_subnet.create_public(self)
        @public_subnet_id = public_subnet.subnet_id
        @public_subnets << public_subnet
        @subnets << private_subnet
        @subnets << public_subnet
      end
    end

    def delete_subnets
      super
      @private_subnets = []
      @public_subnets = []
    end

    def create_route_table
      route_tables = @gateway.select_route_tables_by_name(@config.vpc_name)
      if route_tables.empty?
        private_route_table = VPC::RouteTable.new(self)
        @private_route_table_id = private_route_table.route_table_id
        private_route_table.associate_route_table(self,@private_route_table_id,@private_subnet_id)
        public_route_table = VPC::RouteTable.new(self)
        @public_route_tables << public_route_table.create_public_route(self)
        @public_route_table_id = public_route_table.route_table_id
        public_route_table.associate_route_table(self,@public_route_table_id,@public_subnet_id)
        @route_tables << private_route_table
        @route_tables << public_route_table
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

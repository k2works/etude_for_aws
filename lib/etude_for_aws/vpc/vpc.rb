module VPC
  class Vpc
    include EC2::VpcInterface

    attr_reader :config,
                :gateway

    def initialize
      @config = VPC::Configuration.new
      @gateway = VPC::VpcApiGateway.new
    end

    def set_before_stub
    end

    def set_after_stub
    end

    def create_vpc
      if @vpc_id.nil?
        @vpc_id = @gateway.create_vpc(@config.vpc_name,@config.vpc_cidr_block)
      end
    end

    def delete_vpc
      @gateway.delete_vpc(@vpc_id) unless @vpc_id.nil?
      @vpc_id = nil
    end

    def create_subnets
      subnets = @gateway.select_subnets_by_name(@config.vpc_name)
      if subnets.empty?
        subnet = VPC::Subnet.new(self)
        subnet.create_default(self)
        @subnets << subnet
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
      end
    end

    def delete_internet_gateway
      @internet_gateway.delete(self) unless @internet_gateway.nil?
      @internet_gateway = nil
    end

    def create_route_table
      route_tables = @gateway.select_route_tables_by_name(@config.vpc_name)
      if route_tables.empty?
        route_table = VPC::RouteTable.new(self)
        @route_tables << route_table.create_route(self)
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

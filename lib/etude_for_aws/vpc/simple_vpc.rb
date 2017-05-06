module VPC
  class SimpleVpc < Vpc
    attr_reader :vpc_id,
                :subnet_id,
                :internet_gateway_id,
                :route_table_id

    def initialize
      super
      @gateway.select_vpcs_by_name(@config.vpc_name).each do |vpc|
        @vpc_id = vpc.vpc_id
      end

      @subnets = []
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
      @config.route_table_names.each do |name|
        @gateway.select_route_tables_by_name(name).each do |route_table|
          @route_table_id = route_table.route_table_id
          @route_tables << VPC::RouteTable.new(self)
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

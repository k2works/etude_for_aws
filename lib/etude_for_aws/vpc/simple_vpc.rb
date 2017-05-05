module VPC
  class SimpleVpc < Vpc
    attr_reader :vpc_id,
                :subnet_id,
                :internet_gateway_id,
                :route_table_id

    attr_accessor :subnets,
                  :internet_gateway,
                  :route_tables

    def initialize
      super
      @gateway.select_vpcs_by_name(@config.vpc_name).each do |vpc|
        @vpc_id = vpc.vpc_id
      end

      @subnets = []
      @gateway.select_subnets_by_name(@config.vpc_name).each do |subnet|
        @subnet_id = subnet.subnet_id
        @subnets << VPC::Subnet.new(self)
      end

      @gateway.select_internet_gateways_by_name(@config.vpc_name).each do |internet_gateway|
        @internet_gateway_id = internet_gateway.internet_gateway_id
        @internet_gateway = VPC::InternetGateway.new(self)
      end

      @route_tables = []
      @gateway.select_route_tables_by_name(@config.vpc_name).each do |route_table|
        @route_table_id = route_table.route_table_id
        @route_tables << VPC::RouteTable.new(self)
      end
    end

  end

  class SimpleVpcStub < SimpleVpc
    def initialize
      super
      @config = VPC::ConfigurationStub.new
      @gateway = VPC::VpcApiGatewayStub.new
    end

    def destroy
      set_before_stub
      super
      set_after_stub
    end

    def set_before_stub
      ec2 = @gateway.ec2
      ec2.stub_responses(:describe_vpcs, {
          vpcs:[
              { vpc_id: "String" },
          ],
      })
      ec2.stub_responses(:describe_subnets, {
          subnets:[
              { subnet_id: "String" }
          ],
      })
      ec2.stub_responses(:describe_internet_gateways, {
          internet_gateways:[
              { internet_gateway_id: "String" },
          ],
      })
      ec2.stub_responses(:describe_route_tables, {
          route_tables:[
              { route_table_id: "String" },
          ],
      })
      super
    end

    def set_after_stub
      ec2 = @gateway.ec2
      ec2.stub_responses(:describe_vpcs, {
          vpcs:[],
      })
      ec2.stub_responses(:describe_subnets, {
          subnets:[],
      })
      ec2.stub_responses(:describe_internet_gateways, {
          internet_gateways:[],
      })
      ec2.stub_responses(:describe_route_tables, {
          route_tables:[],
      })
      super
    end

  end
end

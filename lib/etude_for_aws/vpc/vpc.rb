module VPC
  class Vpc
    include EC2::VpcInterface

    attr_reader :vpc_id,
                :subnet_id,
                :internet_gateway_id,
                :route_table_id,
                :config

    attr_accessor :subnets,
                  :internet_gateway,
                  :route_tables

    def initialize
      @config = VPC::Configuration.new
      filter_tag_value = @config.filter_tag_value
      @config.ec2.describe_vpcs({filters: [filter_tag_value], }).vpcs.each do |vpc|
        @vpc_id = vpc.vpc_id
      end
      @subnets = []
      subnets = @config.ec2.describe_subnets({filters: [filter_tag_value], }).subnets
      subnets.each do |subnet|
        @subnet_id = subnet.subnet_id
        @subnets << VPC::Subnet.new(self)
      end

      internet_gateways = @config.ec2.describe_internet_gateways({filters: [filter_tag_value], }).internet_gateways
      internet_gateways.each do |internet_gateway|
        @internet_gateway_id = internet_gateway.internet_gateway_id
        @internet_gateway = VPC::InternetGateway.new(self)
      end

      @route_tables = []
      route_tables = @config.ec2.describe_route_tables({filters: [filter_tag_value], }).route_tables
      route_tables.each do |route_table|
        @route_table_id = route_table.route_table_id
        @route_tables << VPC::RouteTable.new(self)
      end
    end

    def create
      begin

        create_vpc

        create_subnets

        create_internet_gateway

        create_route_table

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end

    def destroy
      begin

        delete_route_tables

        delete_internet_gateway

        delete_subnets

        delete_vpc

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end

    private
    def create_vpc
      if @vpc_id.nil?
        ec2 = get_ec2_client
        resp = ec2.create_vpc({
                                  cidr_block: @config.vpc_cidr_block
                              }
        )
        vpc_id = resp.vpc.vpc_id
        ec2.wait_until(:vpc_exists, {vpc_ids: [vpc_id]})
        ec2.create_tags(resources:[vpc_id],tags: @config.tags)
        @vpc_id = vpc_id
      end
    end

    def delete_vpc
      @config.ec2.delete_vpc({vpc_id: @vpc_id}) unless @vpc_id.nil?
      @vpc_id = nil
    end

    def create_subnets
      ec2 = get_ec2_client
      filter_tag_value = @config.filter_tag_value
      subnets = ec2.describe_subnets({filters: [filter_tag_value], }).subnets
      if subnets.empty?
        @subnets << VPC::Subnet.new(self)
      end
    end

    def delete_subnets
      @subnets.each do |subnet|
        subnet.delete(self)
      end
      @subnets = []
    end

    def create_internet_gateway
      ec2 = get_ec2_client
      filter_tag_value = @config.filter_tag_value
      internet_gateways = ec2.describe_internet_gateways({filters: [filter_tag_value], }).internet_gateways
      if internet_gateways.empty?
        @internet_gateway = VPC::InternetGateway.new(self)
      end
    end

    def delete_internet_gateway
      @internet_gateway.delete(self) unless @internet_gateway.nil?
      @internet_gateway = nil
    end

    def create_route_table
      ec2 = get_ec2_client
      filter_tag_value = @config.filter_tag_value
      route_tables = ec2.describe_route_tables({filters: [filter_tag_value], }).route_tables
      if route_tables.empty?
        @route_tables << VPC::RouteTable.new(self)
      end
    end

    def delete_route_tables
      @route_tables.each do |route_table|
        route_table.delete(self)
      end
      @route_tables = []
    end

    def get_ec2_client
      @config.ec2
    end


    def set_before_stub
    end

    def set_after_stub
    end

  end

  class VpcStub < Vpc
    def initialize
      super
      @config = VPC::ConfigurationStub.new
    end

    def destroy
      set_before_stub
      super
      set_after_stub
    end

    def set_before_stub
      @config.ec2.stub_responses(:describe_vpcs, {
          vpcs:[
              { vpc_id: "String" },
          ],
      })
      @config.ec2.stub_responses(:describe_subnets, {
          subnets:[
              { subnet_id: "String" }
          ],
      })
      @config.ec2.stub_responses(:describe_internet_gateways, {
          internet_gateways:[
              { internet_gateway_id: "String" },
          ],
      })
      @config.ec2.stub_responses(:describe_route_tables, {
          route_tables:[
              { route_table_id: "String" },
          ],
      })
      super
    end

    def set_after_stub
      @config.ec2.stub_responses(:describe_vpcs, {
          vpcs:[],
      })
      @config.ec2.stub_responses(:describe_subnets, {
          subnets:[],
      })
      @config.ec2.stub_responses(:describe_internet_gateways, {
          internet_gateways:[],
      })
      @config.ec2.stub_responses(:describe_route_tables, {
          route_tables:[],
      })
      super
    end

  end
end

module VPC
  class Vpc
    include EC2::VpcInterface

    attr_reader :vpc_id,
                :subnet_id,
                :internet_gateway_id,
                :route_table_id,
                :config

    def initialize
      @config = VPC::Configuration.new
    end

    def create
      begin

        create_vpc

        create_subnet

        create_internet_gateway

        create_route_table

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end

    def destroy
      begin

        set_delete_collection

        delete_route_tables

        delete_internet_gateways

        delete_subnets

        delete_vpcs

        set_delete_ids

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end

    private
    def create_vpc
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

    def delete_vpcs
      @vpcs.each do |vpc|
        @config.ec2.delete_vpc({vpc_id: vpc.vpc_id})
      end
    end

    def create_subnet
      ec2 = get_ec2_client
      resp = ec2.create_subnet({
                                    cidr_block: @config.subnet_cidr_block,
                                    vpc_id: @vpc_id,
                                })
      subnet_id = resp.subnet.subnet_id
      ec2.create_tags(resources:[subnet_id],tags: @config.tags)
      @subnet_id = subnet_id
    end

    def delete_subnets
      @subnets.each do |subnet|
        @config.ec2.delete_subnet({subnet_id: subnet.subnet_id})
      end
    end

    def create_internet_gateway
      ec2 = get_ec2_client
      resp = ec2.create_internet_gateway
      internet_gateway_id = resp.internet_gateway.internet_gateway_id
      ec2.attach_internet_gateway({
                                       internet_gateway_id: internet_gateway_id,
                                       vpc_id: @vpc_id
                                   })
      ec2.create_tags(resources:[internet_gateway_id],tags: @config.tags)
      @internet_gateway_id = internet_gateway_id
    end

    def delete_internet_gateways
      @vpcs.each do |vpc|
        @internet_gateways.each do |internet_gateway|
          ec2 = get_ec2_client
          ec2.detach_internet_gateway({
                                           internet_gateway_id: internet_gateway.internet_gateway_id,
                                           vpc_id: vpc.vpc_id
                                       })
          ec2.delete_internet_gateway({internet_gateway_id: internet_gateway.internet_gateway_id})
        end
      end
    end

    def create_route_table
      ec2 = get_ec2_client
      resp = ec2.create_route_table({
                                         vpc_id: @vpc_id
                                     })
      route_table_id = resp.route_table.route_table_id
      ec2.associate_route_table({
                                     route_table_id: route_table_id,
                                     subnet_id: @subnet_id
                                 })
      ec2.create_tags(resources:[route_table_id],tags: @config.tags)
      ec2.create_route({
                                   destination_cidr_block: @config.destination_cidr_block,
                                   gateway_id: @internet_gateway_id,
                                   route_table_id: route_table_id,
                       })
      @route_table_id = route_table_id
    end

    def delete_route_tables
      ec2 = get_ec2_client
      @route_tables.each do |route_table|
        route_table.associations.each do |association|
          ec2.disassociate_route_table({
                                            association_id: association.route_table_association_id
                                        })
        end
      end

      @route_tables.each do |route_table|
        ec2.delete_route_table({route_table_id: route_table.route_table_id})
      end
    end

    def set_delete_ids
      filter_tag_value = @config.filter_tag_value
      ec2 = get_ec2_client
      @vpc_id = ec2.describe_vpcs({filters: [filter_tag_value], }).vpcs
      @subnet_id = ec2.describe_subnets({filters: [filter_tag_value], }).subnets
      @internet_gateway_id = ec2.describe_internet_gateways({filters: [filter_tag_value], }).internet_gateways
      @route_table_id = ec2.describe_route_tables({filters: [filter_tag_value], }).route_tables
    end

    def set_delete_collection
      filter_tag_value = @config.filter_tag_value
      ec2 = get_ec2_client
      @vpcs = ec2.describe_vpcs({filters: [filter_tag_value], }).vpcs
      @subnets = ec2.describe_subnets({filters: [filter_tag_value], }).subnets
      @internet_gateways = ec2.describe_internet_gateways({filters: [filter_tag_value], }).internet_gateways
      @route_tables = ec2.describe_route_tables({filters: [filter_tag_value], }).route_tables
    end

    def get_ec2_client
      @config.ec2
    end

  end

  class VpcStub < Vpc
    def initialize
      @config = VPC::ConfigurationStub.new
    end

    def set_delete_collection
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

    def set_delete_ids
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

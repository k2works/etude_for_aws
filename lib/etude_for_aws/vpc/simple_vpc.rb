require 'dotenv'

module VPC
  class SimpleVpc
    attr_reader :vpc_id,
                :subnet_id,
                :internet_gateway_id,
                :route_table_id

    def initialize
      @vpc_cidr_block = '10.0.0.0/16'
      @subnet_cidr_block = '10.0.0.0/24'
      @destination_cidr_block = '0.0.0.0/0'
      tag_value = 'TestVpc'
      @tags = {tags: [{key: 'Name', value: tag_value}]}
      @filter_tag_value = {name: 'tag-value', values: [tag_value]}
      Dotenv.load
      @ec2 = Aws::EC2::Client.new
    end

    def create
      begin

        create_vpc

        create_subnet

        create_internet_gateway

        create_route_table

      rescue Exception => e
        puts "Error occurred (#{e.class})"
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
      end
    end

    private
    def create_vpc
      resp = @ec2.create_vpc({
                                 cidr_block: @vpc_cidr_block
                             }
      )
      vpc_id = resp.vpc.vpc_id
      @ec2.wait_until(:vpc_exists, {vpc_ids: [vpc_id]})
      vpc = Aws::EC2::Vpc.new(vpc_id)
      vpc.create_tags(@tags)
      @vpc_id = vpc_id
    end

    def delete_vpcs
      @vpcs.each do |vpc|
        @ec2.delete_vpc({vpc_id: vpc.vpc_id})
      end
    end

    def create_subnet
      resp = @ec2.create_subnet({
                                    cidr_block: @subnet_cidr_block,
                                    vpc_id: @vpc_id,
                                })
      subnet_id = resp.subnet.subnet_id
      @ec2.wait_until(:subnet_available, {subnet_ids: [subnet_id]})
      subnet = Aws::EC2::Subnet.new(subnet_id)
      subnet.create_tags(@tags)
      @subnet_id = subnet_id
    end

    def delete_subnets
      @subnets.each do |subnet|
        @ec2.delete_subnet({subnet_id: subnet.subnet_id})
      end
    end

    def create_internet_gateway
      resp = @ec2.create_internet_gateway
      internet_gateway_id = resp.internet_gateway.internet_gateway_id
      @ec2.attach_internet_gateway({
                                       internet_gateway_id: internet_gateway_id,
                                       vpc_id: @vpc_id
                                   })
      internet_gateway = Aws::EC2::InternetGateway.new(internet_gateway_id)
      internet_gateway.create_tags(@tags)
      @internet_gateway_id = internet_gateway_id
    end

    def delete_internet_gateways
      @vpcs.each do |vpc|
        @internet_gateways.each do |internet_gateway|
          @ec2.detach_internet_gateway({
                                           internet_gateway_id: internet_gateway.internet_gateway_id,
                                           vpc_id: vpc.vpc_id
                                       })
          @ec2.delete_internet_gateway({internet_gateway_id: internet_gateway.internet_gateway_id})
        end
      end
    end

    def create_route_table
      resp = @ec2.create_route_table({
                                         vpc_id: @vpc_id
                                     })
      route_table_id = resp.route_table.route_table_id
      @ec2.associate_route_table({
                                     route_table_id: route_table_id,
                                     subnet_id: @subnet_id
                                 })
      route_table = Aws::EC2::RouteTable.new(route_table_id)
      route_table.create_tags(@tags)
      route_table.create_route({
                                   destination_cidr_block: @destination_cidr_block,
                                   gateway_id: @internet_gateway_id,
                               })
      @route_table_id = route_table_id
    end

    def delete_route_tables
      @route_tables.each do |route_table|
        route_table.associations.each do |association|
          @ec2.disassociate_route_table({
                                            association_id: association.route_table_association_id
                                        })
        end
      end

      @route_tables.each do |route_table|
        @ec2.delete_route_table({route_table_id: route_table.route_table_id})
      end
    end

    def set_delete_ids
      @vpc_id = @ec2.describe_vpcs({filters: [@filter_tag_value], }).vpcs
      @subnet_id = @ec2.describe_subnets({filters: [@filter_tag_value], }).subnets
      @internet_gateway_id = @ec2.describe_internet_gateways({filters: [@filter_tag_value], }).internet_gateways
      @route_table_id = @ec2.describe_route_tables({filters: [@filter_tag_value], }).route_tables
    end

    def set_delete_collection
      @vpcs = @ec2.describe_vpcs({filters: [@filter_tag_value], }).vpcs
      @subnets = @ec2.describe_subnets({filters: [@filter_tag_value], }).subnets
      @internet_gateways = @ec2.describe_internet_gateways({filters: [@filter_tag_value], }).internet_gateways
      @route_tables = @ec2.describe_route_tables({filters: [@filter_tag_value], }).route_tables
    end
  end
end

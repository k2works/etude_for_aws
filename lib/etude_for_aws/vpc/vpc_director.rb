module VPC
  class VpcDirector
    attr_accessor :builder

    def initialize(vpc_builder)
      @builder = vpc_builder
    end

    def create
      begin

        @builder.create_vpc

        @builder.create_subnets

        @builder.create_internet_gateway

        @builder.create_route_table

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end

    def destroy
      begin

        @builder.delete_route_tables

        @builder.delete_internet_gateway

        @builder.delete_subnets

        @builder.delete_vpc

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end
  end
end
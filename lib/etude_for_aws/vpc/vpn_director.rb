module VPC
  class VpnDirector
    attr_accessor :builder

    def initialize(vpc_builder)
      @builder = vpc_builder
    end

    def create
      begin

        @builder.create_customer_gateway

        @builder.create_virtual_gateway

        @builder.attach_vpn_gateway

        @builder.create_vpn_connection

        @builder.create_route

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end

    def destroy
      begin

        @builder.delete_route

        @builder.delete_vpn_connection

        @builder.detach_vpn_gateway

        @builder.delete_virtual_gateway

        @builder.delete_customer_gateway

      rescue Exception => e
        puts "Error occurred (#{e.class})"
        throw e
      end
    end
  end
end
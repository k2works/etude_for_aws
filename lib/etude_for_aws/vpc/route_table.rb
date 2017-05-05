module VPC
  class RouteTable
    attr_reader :route_table_id,
                :associate_route_table_ids

    def initialize(vpc)
      @associate_route_table_ids = []
      if vpc.route_table_id.nil?
        @route_table_id = vpc.gateway.create_route_table(vpc.vpc_id,vpc.config.tags)
      else
        @route_table_id = vpc.route_table_id
        @associate_route_table_ids = vpc.gateway.select_associate_route_table_ids_by_route_table_id(@route_table_id)
      end
    end

    def create_private_route(vpc)
      vpc.gateway.create_route_private(@route_table_id)
      @associate_route_table_ids = vpc.gateway.select_associate_route_table_ids_by_subnets(@route_table_id,vpc.subnets)
    end

    def create_public_route(vpc)
      vpc.gateway.create_route_public(vpc.config.destination_cidr_block,vpc.internet_gateway.internet_gateway_id,@route_table_id)
      @associate_route_table_ids = vpc.gateway.select_associate_route_table_ids_by_subnets(@route_table_id,vpc.subnets)
    end

    def delete(vpc)
      @associate_route_table_ids.each do |id|
        vpc.gateway.disassociate_route_table(id)
      end
      vpc.gateway.delete_route_table(route_table_id)
    end
  end
end
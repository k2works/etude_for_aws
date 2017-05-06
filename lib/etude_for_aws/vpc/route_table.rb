module VPC
  class RouteTable
    attr_reader :route_table_id,
                :associate_route_table_ids

    def initialize(vpc)
      @associate_route_table_ids = []
      unless vpc.route_table_id.nil?
        @route_table_id = vpc.route_table_id
        @associate_route_table_ids = vpc.gateway.select_associate_route_table_ids_by_route_table_id(@route_table_id)
      end
    end

    def create(vpc)
      @route_table_id = vpc.gateway.create_route_table(vpc.vpc_id)
    end

    def create_private_route(vpc)
      vpc.gateway.create_route_private(@route_table_id)
    end

    def create_public_route(vpc,destination_cidr_block,internet_gateway_id)
      vpc.gateway.create_route_public(destination_cidr_block,internet_gateway_id,@route_table_id)
    end

    def associate_route_table(vpc,route_table_id,subnet_id)
      @associate_route_table_ids << vpc.gateway.associate_route_table(route_table_id,subnet_id)
    end

    def delete(vpc)
      @associate_route_table_ids.each do |id|
        vpc.gateway.disassociate_route_table(id)
      end
      vpc.gateway.delete_route_table(route_table_id)
    end
  end
end
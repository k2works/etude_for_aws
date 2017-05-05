module VPC
  class RouteTable
    attr_reader :route_table_id,
                :associate_route_table_ids

    def initialize(vpc)
      @associate_route_table_ids = []
      if vpc.route_table_id.nil?
        @route_table_id = vpc.gateway.create_route_table(vpc)
        @associate_route_table_ids = vpc.gateway.select_associate_route_table_ids_by_subnets(@route_table_id,vpc.subnets)
      else
        @route_table_id = vpc.route_table_id
        @associate_route_table_ids = vpc.gateway.select_associate_route_table_ids_by_route_table_id(@route_table_id)
      end
    end

    def delete(vpc)
      ec2 = vpc.config.ec2
      @associate_route_table_ids.each do |id|
        ec2.disassociate_route_table({
                                         association_id: id
                                     })
      end
      ec2.delete_route_table({route_table_id: @route_table_id})
    end
  end
end
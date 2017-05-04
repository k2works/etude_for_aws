module VPC
  class RouteTable
    attr_reader :route_table_id,
                :associate_route_table_ids

    def initialize(vpc)
      ec2 = vpc.config.ec2
      resp = ec2.create_route_table({
                                        vpc_id: vpc.vpc_id
                                    })
      route_table_id = resp.route_table.route_table_id
      @associate_route_table_ids = []
      vpc.subnets.each do |subnet|
        resp = ec2.associate_route_table({
                                      route_table_id: route_table_id,
                                      subnet_id: subnet.subnet_id
                                  })
        @associate_route_table_ids << resp.association_id
      end

      ec2.create_tags(resources:[route_table_id],tags: vpc.config.tags)
      ec2.create_route({
                           destination_cidr_block: vpc.config.destination_cidr_block,
                           gateway_id: vpc.internet_gateway.internet_gateway_id,
                           route_table_id: route_table_id,
                       })
      @route_table_id = route_table_id
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
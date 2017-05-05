module VPC
  class VpcApiGateway
    include CertificationHelper

    def initialize
      aws_certificate
      @ec2 = Aws::EC2::Client.new
    end

    def select_vpcs_by_name(name)
      filter_tag_value = set_filter_tag_value(name)
      @ec2.describe_vpcs(
          {filters: [filter_tag_value], }
      ).vpcs
    end

    def select_subnets_by_name(name)
      filter_tag_value = set_filter_tag_value(name)
      @ec2.describe_subnets(
          {filters: [filter_tag_value], }
      ).subnets
    end

    def select_internet_gateways_by_name(name)
      filter_tag_value = set_filter_tag_value(name)
      @ec2.describe_internet_gateways(
          {filters: [filter_tag_value], }
      ).internet_gateways
    end

    def select_route_tables_by_name(name)
      filter_tag_value = set_filter_tag_value(name)
      @ec2.describe_route_tables(
          {filters: [filter_tag_value], }
      ).route_tables
    end

    def select_associate_route_table_ids_by_subnets(route_table_id,subnets)
      associate_route_table_ids = []
      subnets.each do |subnet|
        resp = @ec2.associate_route_table({
                                              route_table_id: route_table_id,
                                              subnet_id: subnet.subnet_id
                                          })
        associate_route_table_ids << resp.association_id
      end
      associate_route_table_ids
    end

    def select_associate_route_table_ids_by_route_table_id(route_table_id)
      associate_route_table_ids = []
      resp = @ec2.describe_route_tables({
                                           route_table_ids: [
                                               route_table_id,
                                           ],
                                       })
      resp.route_tables.each do |route_table|
        route_table.associations.each do |association|
          associate_route_table_ids << association.route_table_association_id
        end
      end
      associate_route_table_ids
    end

    def create_subnet(vpc)
      resp = @ec2.create_subnet({
                                   cidr_block: vpc.config.subnet_cidr_block,
                                   vpc_id: vpc.vpc_id,
                               })
      subnet_id = resp.subnet.subnet_id
      tags = [{key: 'Name', value: vpc.config.vpc_name}]
      @ec2.create_tags(resources:[subnet_id],tags: tags)
      subnet_id
    end

    def delete_subnet(subnet_id)
      @ec2.delete_subnet({subnet_id: subnet_id})
    end

    def create_internet_gateway(vpc)
      resp = @ec2.create_internet_gateway
      internet_gateway_id = resp.internet_gateway.internet_gateway_id
      @ec2.attach_internet_gateway({
                                      internet_gateway_id: internet_gateway_id,
                                      vpc_id: vpc.vpc_id
                                  })
      tags = [{key: 'Name', value: vpc.config.vpc_name}]
      @ec2.create_tags(resources:[internet_gateway_id],tags: tags)
      internet_gateway_id
    end

    def detach_internet_gateway(vpc_id,internet_gateway_id)
      @ec2.detach_internet_gateway({
                                      internet_gateway_id: internet_gateway_id,
                                      vpc_id: vpc_id
                                  })
    end

    def delete_internet_gateway(internet_gateway_id)
      @ec2.delete_internet_gateway({internet_gateway_id: internet_gateway_id})
    end

    def create_route_table(vpc)
      resp = @ec2.create_route_table({
                                        vpc_id: vpc.vpc_id
                                    })
      route_table_id = resp.route_table.route_table_id
      @ec2.create_tags(resources:[route_table_id],tags: vpc.config.tags)
      @ec2.create_route({
                           destination_cidr_block: vpc.config.destination_cidr_block,
                           gateway_id: vpc.internet_gateway.internet_gateway_id,
                           route_table_id: route_table_id,
                       })
      route_table_id
    end

    private
    def set_filter_tag_value(name)
      {
          name: 'tag-value', values: [name]
      }
    end
  end

  class VpcApiGatewayStub < VpcApiGateway
    def initialize
      @ec2 = Aws::EC2::Client.new(stub_responses: true)
    end
  end
end
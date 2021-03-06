module VPC
  class VpcApiGateway
    include CertificationHelper

    attr_reader :ec2

    def initialize
      aws_certificate
      @ec2 = Aws::EC2::Client.new
      @stub = false
    end

    def stub?
      @stub
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

    def create_tags(resources,tags)
      @ec2.create_tags(
          resources:resources,
          tags: tags
      )
    end

    def create_vpc(vpc_name,vpc_cidr_block)
      resp = @ec2.create_vpc({
                                cidr_block: vpc_cidr_block
                            }
      )
      vpc_id = resp.vpc.vpc_id
      @ec2.wait_until(:vpc_exists, {vpc_ids: [vpc_id]})
      vpc_id
    end

    def delete_vpc(vpc_id)
      @ec2.delete_vpc({vpc_id: vpc_id})
    end

    def create_subnet(subnet_cidr_block,vpc_id,az)
      resp = @ec2.create_subnet({
                                   cidr_block: subnet_cidr_block,
                                   vpc_id: vpc_id,
                                   availability_zone: az,
                               })
      resp.subnet.subnet_id
    end

    def delete_subnet(subnet_id)
      @ec2.delete_subnet({subnet_id: subnet_id})
    end

    def create_internet_gateway
      resp = @ec2.create_internet_gateway
      resp.internet_gateway.internet_gateway_id
    end

    def attach_internet_gateway(internet_gateway_id, vpc_id)
      @ec2.attach_internet_gateway({
                                       internet_gateway_id: internet_gateway_id,
                                       vpc_id: vpc_id
                                   })
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

    def create_route_table(vpc_id)
      resp = @ec2.create_route_table({
                                        vpc_id: vpc_id
                                    })
      resp.route_table.route_table_id
    end

    def create_route_public(destination_cidr_block,internet_gateway_id,route_table_id)
      resp = @ec2.create_route({
                                   destination_cidr_block: destination_cidr_block,
                                   gateway_id: internet_gateway_id,
                                   route_table_id: route_table_id,
                        })
      resp.return
    end

    def create_route_vpn(destination_cidr_block,vpc_gateway_id,route_table_id)
      resp = @ec2.create_route({
                                   destination_cidr_block: destination_cidr_block,
                                   gateway_id: vpc_gateway_id,
                                   route_table_id: route_table_id,
                               })
      resp.return
    end

    def create_route_private(destination_cidr_block,route_table_id)
      resp = @ec2.create_route({
                                   destination_cidr_block: destination_cidr_block,
                                   route_table_id: route_table_id,
                               })
      resp.return
    end

    def associate_route_table(route_table_id,subnet_id)
      resp = @ec2.associate_route_table({
                                              route_table_id: route_table_id,
                                              subnet_id: subnet_id,
                                          })
      resp.association_id
    end

    def disassociate_route_table(association_id)
      ec2.disassociate_route_table({
                                       association_id: association_id
                                   })
    end

    def delete_route_table(route_table_id)
      @ec2.delete_route_table({route_table_id: route_table_id})
    end

    def select_customer_gateways_by_name(name)
      @ec2.describe_customer_gateways({
                                          filters: [
                                              {
                                                  name: "tag-value",
                                                  values: [name],
                                              },
                                          ],
                                      }).customer_gateways
    end

    def select_vpc_gateways_by_name(name)
      @ec2.describe_vpn_gateways({
                                     filters: [
                                         {
                                             name: "tag-value",
                                             values: [name],
                                         },
                                     ],
                                 }).vpn_gateways
    end

    def select_vpn_connections_by_name(name)
      @ec2.describe_vpn_connections({
                                        filters: [
                                            {
                                                name: "tag-value",
                                                values: [name],
                                            },
                                        ],
                                    }).vpn_connections
    end

    def create_customer_gateway(bgp_asn,public_ip,type)
      @ec2.create_customer_gateway({
                                       bgp_asn: bgp_asn,
                                       public_ip: public_ip,
                                       type: type,
                                   })
    end

    def delete_customer_gateway(customer_gateway_id)
      @ec2.delete_customer_gateway({
                                       customer_gateway_id: customer_gateway_id,
                                   })
    end

    def create_vpn_gateway(type)
      @ec2.create_vpn_gateway({
                                  type: type
                              })
    end

    def attach_vpn_gateway(vpn_gateway_id,vpc_id)
      @ec2.attach_vpn_gateway({
                                  vpn_gateway_id: vpn_gateway_id,
                                  vpc_id: vpc_id,
                              })
    end

    def detach_vpn_gateway(vpn_gateway_id,vpc_id)
      @ec2.detach_vpn_gateway({
                                  vpn_gateway_id: vpn_gateway_id,
                                  vpc_id: vpc_id,
                              })
    end

    def delete_vpn_gateway(vpn_gateway_id)
      @ec2.delete_vpn_gateway({
                                          vpn_gateway_id: vpn_gateway_id,
                                      })
    end

    def create_vpn_connection(type,customer_gateway_id,vpn_gateway_id,static_routes_only)
      @ec2.create_vpn_connection({
                                                    type: type,
                                                    customer_gateway_id: customer_gateway_id,
                                                    vpn_gateway_id: vpn_gateway_id,
                                                    options: {
                                                        static_routes_only: static_routes_only,
                                                    },
                                                })
    end

    def delete_vpn_connection(vpn_connection_id)
      @ec2.delete_vpn_connection({
                                     vpn_connection_id: vpn_connection_id,
                                 })
    end

    def wait_for_vpn_connection_available(vpn_connection_id)
      @ec2.wait_until(:vpn_connection_available, {vpn_connection_ids: [vpn_connection_id]}) unless stub?
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
      @stub = true
    end
  end
end
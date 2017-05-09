module VPC
  class Vpn
    attr_reader :vpc,
                :customer_gateway,
                :virtual_gateway,
                :vpn_connection,
                :route_tables,
                :stub

    def initialize(vpc)
      @vpc = vpc
      @config = vpc.config
      @gateway = vpc.gateway
      @route_tables = []
      @vpc_tags = @config.get_yaml_vpc_tags
      @stub = false
    end

    def stub?
      @stub
    end

    def create_customer_gateway
      resp = @gateway.ec2.create_customer_gateway({
                                                bgp_asn: 65534,
                                                public_ip: "203.0.113.1",
                                                type: "ipsec.1",
                                            })
      @customer_gateway = resp
      resources = [@customer_gateway[0].customer_gateway_id]
      tag = {key: @vpc_tags['NAME']['KEY'], value: 'TestCustomerGateway'}
      tags = [tag,@config.vpc_group_tag]
      @gateway.create_tags(resources,tags)
    end

    def create_virtual_gateway
      resp = @gateway.ec2.create_vpn_gateway({
                                           type: "ipsec.1"
                                       })
      @virtual_gateway = resp

      resources = [@virtual_gateway[0].vpn_gateway_id]
      tag = {key: @vpc_tags['NAME']['KEY'], value: 'TestVpnGateway'}
      tags = [tag,@config.vpc_group_tag]
      @gateway.create_tags(resources,tags)
    end

    def attach_vpn_gateway
      resp = @gateway.ec2.attach_vpn_gateway({
                                                 dry_run: false,
                                                 vpn_gateway_id: @virtual_gateway[0].vpn_gateway_id,
                                                 vpc_id: @vpc.vpc_id,
                                             })

      resp
    end

    def create_vpn_connection
      resp = @gateway.ec2.create_vpn_connection({
                                              type: "ipsec.1",
                                              customer_gateway_id: @customer_gateway[0].customer_gateway_id,
                                              vpn_gateway_id: @virtual_gateway[0].vpn_gateway_id,
                                              options: {
                                                  static_routes_only: true,
                                              },
                                          })
      @vpn_connection = resp
      resources = [@vpn_connection[0].vpn_connection_id]
      tag = {key: @vpc_tags['NAME']['KEY'], value: 'TestVpnConnection'}
      tags = [tag,@config.vpc_group_tag]
      @gateway.create_tags(resources,tags)
    end

    def create_route
      @config.private_route_tables.each do |v|
        destination_cidr_block = '192.168.0.0/16'
        name = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
        route_tables = @gateway.select_route_tables_by_name(name)
        route_tables.each do |route_table|
          @gateway.create_route_vpn(destination_cidr_block,@virtual_gateway[0].vpn_gateway_id,route_table.route_table_id)
          @route_tables << route_table
        end
      end
    end

    def delete_customer_gateway
      resp = @gateway.ec2.describe_customer_gateways({
                                                   filters: [
                                                       {
                                                           name: "tag-value",
                                                           values: ["TestCustomerGateway"],
                                                       },
                                                   ],
                                               })
      unless resp.customer_gateways.empty?
        customer_gateway_id = resp.customer_gateways[0].customer_gateway_id
        resp = @gateway.ec2.delete_customer_gateway({
                                                  customer_gateway_id: customer_gateway_id,
                                              })
        @customer_gateway = resp
      end
    end

    def delete_virtual_gateway
      resp = @gateway.ec2.describe_vpn_gateways({
                                                         filters: [
                                                             {
                                                                 name: "tag-value",
                                                                 values: ["TestVpnGateway"],
                                                             },
                                                         ],
                                                     })
      unless resp.vpn_gateways.empty?
        vpn_gateway_id = resp.vpn_gateways[0].vpn_gateway_id
        resp = @gateway.ec2.delete_vpn_gateway({
                                             dry_run: false,
                                             vpn_gateway_id: vpn_gateway_id,
                                         })
        @virtual_gateway = resp
      end
    end

    def detach_vpn_gateway
      resp = @gateway.ec2.describe_vpn_gateways({
                                                    filters: [
                                                        {
                                                            name: "tag-value",
                                                            values: ["TestVpnGateway"],
                                                        },
                                                    ],
                                                })

      unless resp.vpn_gateways.empty?
        vpn_gateway_id = resp.vpn_gateways[0].vpn_gateway_id
        resp = @gateway.ec2.detach_vpn_gateway({
                                             vpn_gateway_id: vpn_gateway_id,
                                             vpc_id: @vpc.vpc_id,
                                         })
        resp
      end
    end

    def delete_vpn_connection
      resp = @gateway.ec2.describe_vpn_connections({
                                                    filters: [
                                                        {
                                                            name: "tag-value",
                                                            values: ["TestVpnConnection"],
                                                        },
                                                    ],
                                                })

      unless resp.vpn_connections.empty?
        vpn_connection_id = resp.vpn_connections[0].vpn_connection_id
        resp = @gateway.ec2.delete_vpn_connection({
                                                vpn_connection_id: vpn_connection_id,
                                            })
        @vpn_connection = resp
      end
    end

    def delete_route
      @route_tables.each do |route_table|
        route_table_id = route_table.route_table_id
        @associate_route_table_ids = @gateway.select_associate_route_table_ids_by_route_table_id(route_table_id)
        @associate_route_table_ids.each do |id|
          @gateway.disassociate_route_table(id)
        end
        @gateway.delete_route_table(route_table_id)
      end
    end
  end

  class VpnStub < Vpn
    def initialize(vpc)
      super
      @stub = true
    end

    def delete_customer_gateway
      @gateway.ec2.stub_responses(:describe_customer_gateways,
                                     {
                                         customer_gateways: [
                                             {
                                                 customer_gateway_id: 'String',
                                                 tags: [
                                                     {
                                                         key:'Name',
                                                         value: 'TestCustomerGateway'
                                                     }
                                                 ]
                                             }
                                         ]
                                     })
      super
    end

    def delete_virtual_gateway
      @gateway.ec2.stub_responses(:describe_vpn_gateways,
                                  {
                                      vpn_gateways: [
                                          {
                                              vpn_gateway_id: 'String',
                                              tags: [
                                                  {
                                                      key:'Name',
                                                      value: 'TestVpnGateway'
                                                  }
                                              ]
                                          }
                                      ]
                                  })

      super
    end

    def detach_vpn_gateway
      @gateway.ec2.stub_responses(:describe_vpn_gateways,
                                  {
                                      vpn_gateways: [
                                          {
                                              vpn_gateway_id: 'String',
                                              tags: [
                                                  {
                                                      key:'Name',
                                                      value: 'TestVpnGateway'
                                                  }
                                              ]
                                          }
                                      ]
                                  })

      super
    end

    def delete_vpn_connection
      @gateway.ec2.stub_responses(:describe_vpn_connections,
                                  {
                                      vpn_connections: [
                                          {
                                              vpn_connection_id: 'String',
                                              tags: [
                                                  {
                                                      key:'Name',
                                                      value: 'TestVpnGateway'
                                                  }
                                              ]
                                          }
                                      ]
                                  })

      super
    end

    def delete_route
      super
      @route_tables = []
    end
  end
end
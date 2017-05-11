module VPC
  class Vpn
    attr_reader :vpc,
                :customer_gateways,
                :vpn_gateway,
                :vpn_connections,
                :route_tables,
                :stub

    def initialize(vpc)
      @vpc = vpc
      @config = vpc.config
      @gateway = vpc.gateway
      @route_tables = []
      @vpc_tags = @config.get_yaml_vpc_tags
      @stub = false

      setup_customer_gateways
      setup_vpn_gateway
      setup_vpn_connections
    end

    def stub?
      @stub
    end

    def create_customer_gateway
      customer_gateways_info = @config.get_vpn_customer_gateways
      customer_gateways_info.each do |customer_gateway_config|
        customer_gateway_info = customer_gateway_config['CONFIG']['CUSTOMER_GATEWAY']
        customer_gateway = CustomerGateway.new(@config,@gateway)
        customer_gateway.create(customer_gateway_info)
        @customer_gateways << customer_gateway
      end
    end

    def create_vpn_gateway
      vpn_gateway_info = @config.get_vpn_gateway
      @vpn_gateway = VpnGateway.new(@config,@gateway)
      @vpn_gateway.create(vpn_gateway_info)
    end

    def attach_vpn_gateway
      @vpn_gateway.attach(@vpc.vpc_id)
    end

    def create_vpn_connection
      n = 0
      vpn_connections_info = @config.get_vpn_connections
      vpn_connections_info.each do |vpn_connection_config|
        vpn_connection_info = vpn_connection_config['CONFIG']['VPN_CONNECTION']
        customer_gateway_id = @customer_gateways[n].customer_gateway_id
        vpn_gateway_id = @vpn_gateway.vpn_gateway_id
        vpn_connection = VpnConnection.new(@config,@gateway)
        vpn_connection.creat(customer_gateway_id, vpn_gateway_id, vpn_connection_info)
        @vpn_connections << vpn_connection
        n += 1
      end
    end

    def create_route
      @vpn_connections.each do |vpn_connection|
        vpn_connection_id = vpn_connection.vpn_connection_id
        @gateway.wait_for_vpn_connection_available(vpn_connection_id)

        @config.private_route_tables.each do |v|
          name = v['CONFIG']['ROUTE_TABLE_TAGS'].first['NAME']['VALUE']
          destination_cidr_blocks = @config.get_vpn_gateway['DESTINATION_CIDR_BLOCKS']
          destination_cidr_blocks.each do |cidr_block|
            route_tables = @gateway.select_route_tables_by_name(name)
            route_tables.each do |route_table|
              @gateway.create_route_vpn(cidr_block['CIDR'],@vpn_gateway.vpn_gateway_id,route_table.route_table_id)
              @route_tables << route_table
            end
          end
        end
      end
    end

    def delete_customer_gateway
      resp = []
      @customer_gateways.each do |customer_gateway|
        resp << customer_gateway.delete
      end
      @customer_gateways = []
      @customer_gateways = resp
    end

    def delete_vpn_gateway
      @vpn_gateway = @vpn_gateway.delete
    end

    def detach_vpn_gateway
      @vpn_gateway.detach(@vpc.vpc_id)
    end

    def delete_vpn_connection
      resp = []
      @vpn_connections.each do |vpn_connection|
        resp << vpn_connection.delete
      end
      @vpn_connections = []
      @vpn_connections = resp
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

    private
    def setup_customer_gateways
      @customer_gateways = []
      customer_gateways_info = @config.get_vpn_customer_gateways
      customer_gateways_info.each do |customer_gateway_config|
        tags = customer_gateway_config['CONFIG']['CUSTOMER_GATEWAY']['TAGS']
        value = tags['NAME']['VALUE']
        customer_gateways = @gateway.select_customer_gateways_by_name(value)
        unless customer_gateways.empty?
          customer_gateway_id = customer_gateways[0].customer_gateway_id
          @customer_gateways << CustomerGateway.new(@config, @gateway, customer_gateway_id)
        end
      end
    end

    def setup_vpn_gateway
      value = @config.get_vpn_gateway['TAGS']['NAME']['VALUE']
      vpn_gateways = @gateway.select_vpc_gateways_by_name(value)
      unless vpn_gateways.empty?
        @vpn_gateway = vpn_gateways[0]
      end
    end

    def setup_vpn_connections
      @vpn_connections = []
      vpn_connections_info = @config.get_vpn_connections
      vpn_connections_info.each do |vpn_connection_config|
        tags = vpn_connection_config['CONFIG']['VPN_CONNECTION']['TAGS']
        value = tags['NAME']['VALUE']
        vpn_connections = @gateway.select_vpn_connections_by_name(value)

        unless vpn_connections.empty?
          vpn_connection_id = vpn_connections[0].vpn_connection_id
          vpn_connection = VpnConnection.new(@config, @gateway, vpn_connection_id)
          @vpn_connections << vpn_connection
        end
      end
    end
  end

  class CustomerGateway
    attr_reader :customer_gateway_id

    def initialize(config,gateway,customer_gateway_id=nil)
      @config = config
      @gateway = gateway
      @customer_gateway_id = customer_gateway_id
    end

    def create(customer_gateway_info)
      bgp_asn = customer_gateway_info['BGP_ASN']
      public_ip = customer_gateway_info['PUBLIC_IP']
      type = customer_gateway_info['TYPE']
      customer_gateway = @gateway.create_customer_gateway(bgp_asn, public_ip, type)
      @customer_gateway_id = customer_gateway[0].customer_gateway_id
      resources = [@customer_gateway_id]
      customer_gateway_tags = customer_gateway_info['TAGS']
      tag = {key: customer_gateway_tags['NAME']['KEY'], value: customer_gateway_tags['NAME']['VALUE']}
      tags = [tag, @config.vpc_group_tag]
      @gateway.create_tags(resources, tags)
    end

    def delete
      @gateway.delete_customer_gateway(@customer_gateway_id)
    end
  end

  class VpnGateway
    attr_reader :vpn_gateway_id

    def initialize(config,gateway,vpn_gateway_id=nil)
      @config = config
      @gateway = gateway
      @vpn_gateway_id = vpn_gateway_id
    end

    def create(vpn_gateway_info)
      type = vpn_gateway_info['TYPE']

      virtual_gateway = @gateway.create_vpn_gateway(type)
      @vpn_gateway_id = virtual_gateway[0].vpn_gateway_id
      resources = [vpn_gateway_id]
      vpn_gateway_tags = vpn_gateway_info['TAGS']
      tag = {key: vpn_gateway_tags['NAME']['KEY'], value: vpn_gateway_tags['NAME']['VALUE']}
      tags = [tag, @config.vpc_group_tag]
      @gateway.create_tags(resources, tags)
    end

    def attach(vpc_id)
      @gateway.attach_vpn_gateway(@vpn_gateway_id,vpc_id)
    end

    def detach(vpc_id)
      @gateway.detach_vpn_gateway(@vpn_gateway_id,vpc_id)
    end

    def delete
      @gateway.delete_vpn_gateway(@vpn_gateway_id)
    end

  end

  class VpnConnection
    attr_reader :vpn_connection_id

    def initialize(config,gateway,vpn_connection_id=nil)
      @config = config
      @gateway = gateway
      @vpn_connection_id = vpn_connection_id
    end

    def creat(customer_gateway_id, vpn_gateway_id, vpn_connection_info)
      type = vpn_connection_info['TYPE']
      static_routes_only = vpn_connection_info['OPTIONS']['STATIC_ROUTES_ONLY']
      @vpn_connection = @gateway.create_vpn_connection(type, customer_gateway_id, vpn_gateway_id, static_routes_only)
      @vpn_connection_id = @vpn_connection[0].vpn_connection_id
      resources = [@vpn_connection_id]
      vpn_connection_tags = vpn_connection_info['TAGS']
      tag = {key: vpn_connection_tags['NAME']['KEY'], value: vpn_connection_tags['NAME']['VALUE']}
      tags = [tag, @config.vpc_group_tag]
      @gateway.create_tags(resources, tags)
    end

    def delete
      @gateway.delete_vpn_connection(@vpn_connection_id)
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
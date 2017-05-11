module VPC
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
end
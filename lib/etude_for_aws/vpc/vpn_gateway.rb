module VPC
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
end
module VPC
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
end
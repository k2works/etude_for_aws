module VPC
  class InternetGateway
    attr_accessor :internet_gateway_id

    def create(vpc)
      @internet_gateway_id = vpc.gateway.create_internet_gateway
      vpc.gateway.attach_internet_gateway(@internet_gateway_id, vpc.vpc_id)
    end

    def delete(vpc)
      vpc.gateway.detach_internet_gateway(vpc.vpc_id,@internet_gateway_id)
      vpc.gateway.delete_internet_gateway(@internet_gateway_id)
    end
  end
end
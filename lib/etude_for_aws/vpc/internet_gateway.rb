module VPC
  class InternetGateway
    attr_accessor :internet_gateway_id

    def initialize(vpc)
      if vpc.internet_gateway_id.nil?
        @internet_gateway_id = vpc.gateway.create_internet_gateway(vpc.config.vpc_name)
        vpc.gateway.attach_internet_gateway(@internet_gateway_id, vpc.vpc_id)
      else
        @internet_gateway_id = vpc.internet_gateway_id
      end
    end

    def delete(vpc)
      vpc.gateway.detach_internet_gateway(vpc.vpc_id,@internet_gateway_id)
      vpc.gateway.delete_internet_gateway(@internet_gateway_id)
    end
  end
end
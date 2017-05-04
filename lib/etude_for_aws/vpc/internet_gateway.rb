module VPC
  class InternetGateway
    attr_accessor :internet_gateway_id

    def initialize(vpc)
      ec2 = vpc.config.ec2
      resp = ec2.create_internet_gateway
      internet_gateway_id = resp.internet_gateway.internet_gateway_id
      ec2.attach_internet_gateway({
                                      internet_gateway_id: internet_gateway_id,
                                      vpc_id: vpc.vpc_id
                                  })
      ec2.create_tags(resources:[internet_gateway_id],tags: vpc.config.tags)
      @internet_gateway_id = internet_gateway_id
    end

    def delete(vpc)
      ec2 = vpc.config.ec2
      ec2.detach_internet_gateway({
                                      internet_gateway_id: @internet_gateway_id,
                                      vpc_id: vpc.vpc_id
                                  })
      ec2.delete_internet_gateway({internet_gateway_id: @internet_gateway_id})
    end
  end
end
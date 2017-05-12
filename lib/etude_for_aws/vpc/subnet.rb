module VPC
  class Subnet
    attr_accessor :subnet_id,:az

    def create(vpc,subnet_cidr_block,az)
      @az = az
      @subnet_id = vpc.gateway.create_subnet(subnet_cidr_block,vpc.vpc_id,az)
    end

    def delete(vpc)
      vpc.gateway.delete_subnet(@subnet_id)
    end
  end
end
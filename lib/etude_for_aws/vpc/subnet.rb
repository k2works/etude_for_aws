module VPC
  class Subnet
    attr_reader :subnet_id

    def initialize(vpc)
      if vpc.subnet_id.nil?
        @subnet_id = vpc.gateway.create_subnet(vpc.config.subnet_cidr_block,vpc.vpc_id,vpc.config.vpc_name)
      else
        @subnet_id = vpc.subnet_id
      end
    end

    def delete(vpc)
      vpc.gateway.delete_subnet(@subnet_id)
    end
  end
end
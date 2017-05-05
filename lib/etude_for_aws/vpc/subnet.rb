module VPC
  class Subnet
    attr_reader :subnet_id

    def initialize(vpc)
      @subnet_id = vpc.subnet_id unless vpc.subnet_id.nil?
    end

    def create_default(vpc)
      @subnet_id = vpc.gateway.create_subnet(vpc.config.subnet_cidr_block,vpc.vpc_id,vpc.config.vpc_name)
    end

    def create_private(vpc)
      @subnet_id = vpc.gateway.create_subnet(vpc.config.subnet_cidr_block_private,vpc.vpc_id,vpc.config.vpc_name)
    end

    def create_public(vpc)
      @subnet_id = vpc.gateway.create_subnet(vpc.config.subnet_cidr_block_public,vpc.vpc_id,vpc.config.vpc_name)
    end

    def delete(vpc)
      vpc.gateway.delete_subnet(@subnet_id)
    end
  end
end
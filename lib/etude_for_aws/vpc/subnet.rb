module VPC
  class Subnet
    attr_reader :subnet_id

    def initialize(vpc)
      ec2 = vpc.config.ec2
      resp = ec2.create_subnet({
                                   cidr_block: vpc.config.subnet_cidr_block,
                                   vpc_id: vpc.vpc_id,
                               })
      subnet_id = resp.subnet.subnet_id
      ec2.create_tags(resources:[subnet_id],tags: vpc.config.tags)
      @subnet_id = subnet_id
    end

    def delete(vpc)
      ec2 = vpc.config.ec2
      ec2.delete_subnet({subnet_id: @subnet_id})
    end
  end
end
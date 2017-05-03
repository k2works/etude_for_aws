require 'dotenv'

module VPC
  class SimpleVpc
    def self.create
      Dotenv.load
      ec2 = Aws::EC2::Client.new
      resp = ec2.create_vpc({
          cidr_block: '10.0.0.0/16'
                     }
      )
      id = resp.vpc.vpc_id
      ec2.wait_until(:vpc_exists, {vpc_ids: [id]})
      vpc = Aws::EC2::Vpc.new(id)
      vpc.create_tags({tags: [{key: 'Name', value: 'TestVpc'}]})
      vpc_id = ec2.describe_vpcs({filters:[{name:'tag-value',values:['TestVpc']}],}).vpcs[0].vpc_id
      vpc_id
    end

    def self.destroy
      Dotenv.load
      ec2 = Aws::EC2::Client.new
      vpc_id = ec2.describe_vpcs({filters:[{name:'tag-value',values:['TestVpc']}],}).vpcs[0].vpc_id
      ec2.delete_vpc({vpc_id:vpc_id})
      vpc_id
    end
  end
end

require 'dotenv'

module VPC
  class SimpleVpc
    def self.create
      ret = {}
      Dotenv.load
      ec2 = Aws::EC2::Client.new

      # VPCを作成する
      resp = ec2.create_vpc({
          cidr_block: '10.0.0.0/16'
                     }
      )
      vpc_id = resp.vpc.vpc_id
      ec2.wait_until(:vpc_exists, {vpc_ids: [vpc_id]})
      vpc = Aws::EC2::Vpc.new(vpc_id)
      vpc.create_tags({tags: [{key: 'Name', value: 'TestVpc'}]})

      # サブネットを作成する
      resp = ec2.create_subnet({
                                   cidr_block:'10.0.0.0/24',
                                   vpc_id: vpc_id,
                               })
      subnet_id = resp.subnet.subnet_id
      ec2.wait_until(:subnet_available, {subnet_ids: [subnet_id]})
      subnet = Aws::EC2::Subnet.new(subnet_id)
      subnet.create_tags({tags: [{key: 'Name', value: 'TestVpc'}]})

      ret[:vpc_id] = vpc_id
      ret[:subnet_id] = subnet_id
      ret
    end

    def self.destroy
      ret = {}
      Dotenv.load
      ec2 = Aws::EC2::Client.new

      # VPCを削除する
      subnet_id = ec2.describe_subnets({filters:[{name:'tag-value',values:['TestVpc']}],}).subnets[0].subnet_id
      ec2.delete_subnet({subnet_id:subnet_id})

      # サブネットを削除する
      vpc_id = ec2.describe_vpcs({filters:[{name:'tag-value',values:['TestVpc']}],}).vpcs[0].vpc_id
      ec2.delete_vpc({vpc_id:vpc_id})
      vpc_id

      ret[:vpc_id] = vpc_id
      ret[:subnet_id] = subnet_id
      ret
    end
  end
end

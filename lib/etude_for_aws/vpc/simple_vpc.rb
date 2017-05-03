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

      # インターネットゲートウェイを作成する
      resp = ec2.create_internet_gateway
      internet_gateway_id = resp.internet_gateway.internet_gateway_id
      ec2.attach_internet_gateway({
          internet_gateway_id: internet_gateway_id,
          vpc_id: vpc_id
                                  })
      internet_gateway = Aws::EC2::InternetGateway.new(internet_gateway_id)
      internet_gateway.create_tags({tags: [{key: 'Name', value: 'TestVpc'}]})

      ret[:vpc_id] = vpc_id
      ret[:subnet_id] = subnet_id
      ret[:internet_gateway_id] = internet_gateway_id
      ret
    end

    def self.destroy
      ret = {}
      Dotenv.load
      ec2 = Aws::EC2::Client.new

      vpc_id = ec2.describe_vpcs({filters:[{name:'tag-value',values:['TestVpc']}],}).vpcs[0].vpc_id
      subnet_id = ec2.describe_subnets({filters:[{name:'tag-value',values:['TestVpc']}],}).subnets[0].subnet_id
      internet_gateway_id = ec2.describe_internet_gateways({filters:[{name:'tag-value',values:['TestVpc']}],}).internet_gateways[0].internet_gateway_id

      # インターネットゲートウェイを削除する
      ec2.detach_internet_gateway({
                                      internet_gateway_id: internet_gateway_id,
                                      vpc_id: vpc_id
                                  })
      resp = ec2.delete_internet_gateway({internet_gateway_id:internet_gateway_id})
      internet_gateway_id = resp

      # サブネットを削除する
      resp = ec2.delete_subnet({subnet_id:subnet_id})
      subnet_id = resp

      # VPCを削除する
      resp = ec2.delete_vpc({vpc_id:vpc_id})
      vpc_id = resp

      ret[:vpc_id] = vpc_id.to_s
      ret[:subnet_id] = subnet_id.to_s
      ret[:internet_gateway_id] = internet_gateway_id.to_s
      ret
    end
  end
end

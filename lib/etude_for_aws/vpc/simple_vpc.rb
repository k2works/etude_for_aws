require 'dotenv'

module VPC
  class SimpleVpc
    def create
      begin
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

        # ルートテーブルを作成する
        resp = ec2.create_route_table({
                                          vpc_id: vpc_id
                                      })
        route_table_id = resp.route_table.route_table_id
        ec2.associate_route_table({
                                      route_table_id: route_table_id,
                                      subnet_id: subnet_id
                                  })
        route_table = Aws::EC2::RouteTable.new(route_table_id)
        route_table.create_tags({tags: [{key: 'Name', value: 'TestVpc'}]})
        route_table.create_route({
                                     destination_cidr_block:'0.0.0.0/0',
                                     gateway_id:internet_gateway_id,
                                 })

        ret[:vpc_id] = vpc_id
        ret[:subnet_id] = subnet_id
        ret[:internet_gateway_id] = internet_gateway_id
        ret[:route_table_id] = route_table_id
        ret
      rescue Exception => e
        puts "Error occurred (#{e.class})"
      end
    end

    def destroy
      begin
        ret = {}
        Dotenv.load
        ec2 = Aws::EC2::Client.new

        vpcs = ec2.describe_vpcs({filters:[{name:'tag-value',values:['TestVpc']}],}).vpcs
        subnets = ec2.describe_subnets({filters:[{name:'tag-value',values:['TestVpc']}],}).subnets
        internet_gateways = ec2.describe_internet_gateways({filters:[{name:'tag-value',values:['TestVpc']}],}).internet_gateways
        route_tables = ec2.describe_route_tables({filters:[{name:'tag-value',values:['TestVpc']}],}).route_tables

        # ルートテーブルを削除する
        route_tables.each do |route_table|
          route_table.associations.each do |association|
            ec2.disassociate_route_table({
                                             association_id: association.route_table_association_id
                                         })
          end
        end

        route_tables.each do |route_table|
          ec2.delete_route_table({route_table_id: route_table.route_table_id})
        end

        # インターネットゲートウェイを削除する
        vpcs.each do |vpc|
          internet_gateways.each do |internet_gateway|
            ec2.detach_internet_gateway({
                                            internet_gateway_id: internet_gateway.internet_gateway_id,
                                            vpc_id: vpc.vpc_id
                                        })
            ec2.delete_internet_gateway({internet_gateway_id: internet_gateway.internet_gateway_id})
          end

        end
        # サブネットを削除する
        subnets.each do |subnet|
          ec2.delete_subnet({subnet_id:subnet.subnet_id})
        end

        # VPCを削除する
        vpcs.each do |vpc|
          ec2.delete_vpc({vpc_id:vpc.vpc_id})
        end

        ret[:vpc_id] = ec2.describe_vpcs({filters:[{name:'tag-value',values:['TestVpc']}],}).vpcs
        ret[:subnet_id] = ec2.describe_subnets({filters:[{name:'tag-value',values:['TestVpc']}],}).subnets
        ret[:internet_gateway_id] = ec2.describe_internet_gateways({filters:[{name:'tag-value',values:['TestVpc']}],}).internet_gateways
        ret[:route_table_id] = ec2.describe_route_tables({filters:[{name:'tag-value',values:['TestVpc']}],}).route_tables
        ret
      rescue Exception => e
        puts "Error occurred (#{e.class})"
      end
    end
  end
end

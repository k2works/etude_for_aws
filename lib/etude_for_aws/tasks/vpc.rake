require 'etude_for_aws'

namespace :VPC do
  desc 'シンプルなVPCを作成する'
  task :create_simple_vpc do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc_director.create
  end

  desc 'シンプルなVPCを削除する'
  task :destroy_simple_vpc do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc_director.destroy
  end

  desc '標準的なVPCを作成する'
  task :create_standard_vpc do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc_director.create
  end

  desc '標準的なVPCを削除する'
  task :destroy_standard_vpc do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc_director.destroy
  end
end
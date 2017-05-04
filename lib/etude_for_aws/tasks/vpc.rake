require 'etude_for_aws'

namespace :VPC do
  desc 'VPCを作成する'
  task :create_vpc do
    VPC::Vpc.new.create
  end

  desc 'VPCを削除する'
  task :destroy_vpc do
    VPC::Vpc.new.destroy
  end

  desc 'シンプルなVPCを作成する'
  task :create_simple_vpc do
    VPC::SimpleVpc.new.create
  end

  desc 'シンプルなVPCを削除する'
  task :destroy_simple_vpc do
    VPC::SimpleVpc.new.destroy
  end
end
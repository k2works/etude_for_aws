require 'etude_for_aws'

namespace :VPC do
  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットVPCを作成する'
  task :create_type01_vpc do
    VPC::OneAzOnePublicSubnetVpc.new.create
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットVPCを削除する'
  task :destroy_type01_vpc do
    VPC::OneAzOnePublicSubnetVpc.new.destroy
  end

  desc '１つのアベイラビリティゾーンに２つのパブリックサブネットVPCを作成する'
  task :create_type02_vpc do
    VPC::OneAzTwoPublicSubnetVpc.new.create
  end

  desc '１つのアベイラビリティゾーンに２つのパブリックサブネットVPCを削除する'
  task :destroy_type02_vpc do
    VPC::OneAzTwoPublicSubnetVpc.new.destroy
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットVPCを作成する'
  task :create_type03_vpc do
    VPC::OneAzTwoPublicAndPrivateSubnetVpc.new.create
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットを削除する'
  task :destroy_type03_vpc do
    VPC::OneAzTwoPublicAndPrivateSubnetVpc.new.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのプライベートサブネットVPCを作成する'
  task :create_type04_vpc do
    VPC::TwoAzTwoPrivateSubnetVpc.new.create
  end

  desc '２つのアベイラビリティゾーンに２つのプライベートサブネットを削除する'
  task :destroy_type04_vpc do
    VPC::TwoAzTwoPrivateSubnetVpc.new.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットVPCを作成する'
  task :create_type05_vpc do
    VPC::TwoAzTwoPublicSubnetVpc.new.create
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットVPCを削除する'
  task :destroy_type05_vpc do
    VPC::TwoAzTwoPublicSubnetVpc.new.destroy
  end

  desc '２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットVPCを作成する'
  task :create_type06_vpc do
    VPC::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new.create
  end

  desc '２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットVPCを削除する'
  task :destroy_type06_vpc do
    VPC::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCを作成する'
  task :create_type07_vpc do
    VPC::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new.create
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCを削除する'
  task :destroy_type07_vpc do
    VPC::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new.destroy
  end
end
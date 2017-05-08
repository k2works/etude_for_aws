require 'etude_for_aws'

namespace :EC2 do
  task :default => :create_type01_env

  desc 'シンプルなVPC環境にEC2インスタンスを作成する'
  task :create_simple_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc_director.create
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).create
  end

  desc 'シンプルなVPC環境のEC2インスタンスを削除する'
  task :destroy_simple_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).destroy
    vpc_director.destroy
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境を作成する'
  task :setup_type01_env => [:create_type01,:copy_key_pair] do
    puts '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境を作成しました。'
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type01 do
    vpc = VPC::OneAzOnePublicSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type01_env do
    vpc = VPC::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを停止する'
  task :stop_type01 do
    vpc = VPC::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).stop
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを起動する'
  task :start_type01 do
    vpc = VPC::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).start
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを再起動する'
  task :reboot_type01 do
    vpc = VPC::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).reboot
  end

  desc '１つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type02 do
    vpc = VPC::OneAzTwoPublicSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '１つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type02_env do
    vpc = VPC::OneAzTwoPublicSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type03 do
    vpc = VPC::OneAzTwoPublicAndPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type03_env do
    vpc = VPC::OneAzTwoPublicAndPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type04 do
    vpc = VPC::TwoAzTwoPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type04_env do
    vpc = VPC::TwoAzTwoPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type05 do
    vpc = VPC::TwoAzTwoPublicSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type05_env do
    vpc = VPC::TwoAzTwoPublicSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type06 do
    vpc = VPC::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type06_env do
    vpc = VPC::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type07 do
    vpc = VPC::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCのVPC環境のEC2インスタンスを削除する'
  task :destroy_type07_env do
    vpc = VPC::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '作成したキーペアをコピーする'
  task :copy_key_pair do
    yaml = YAML.load_file('config.yml')
    key_pair_name = yaml['DEV']['EC2']['KEY_PAIR_NAME']
    path = Dir.pwd + yaml['DEV']['EC2']['KEY_PAIR_PATH']
    pem_file = path + "#{key_pair_name}.pem"
    FileUtils.cp(pem_file,Dir.pwd)
  end
end


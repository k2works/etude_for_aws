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

  desc 'シンプルなVPC環境にEC2インスタンス起動する'
  task :start_simple_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).start
  end

  desc 'シンプルなVPC環境にEC2インスタンス再起動する'
  task :reboot_simple_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).reboot
  end

  desc 'シンプルなVPC環境にEC2インスタンス停止する'
  task :stop_simple_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::SimpleVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).stop
  end

  desc '標準的なVPC環境にEC2インスタンスを作成する'
  task :create_standard_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc_director.create
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).create
  end

  desc '標準的なVPC環境のEC2インスタンスを削除する'
  task :destroy_standard_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).destroy
    vpc_director.destroy
  end

  desc '標準的なVPC環境にEC2インスタンスを起動する'
  task :start_standard_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).start
  end

  desc '標準的なVPC環境にEC2インスタンスを再起動する'
  task :reboot_standard_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).reboot
  end

  desc '標準的なVPC環境にEC2インスタンスを停止する'
  task :stop_standard_vpc_env do
    vpc_director = VPC::VpcDirector.new(VPC::StandardVpc.new)
    vpc = vpc_director.builder
    EC2::Ec2.new(vpc).stop
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境を作成する'
  task :setup_type01_env => [:create_type01,:copy_key_pair] do
    puts '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境を作成しました。'
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type01 do
    vpc = CFM::OneAzOnePublicSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type01_env do
    vpc = CFM::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを停止する'
  task :stop_type01 do
    vpc = CFM::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).stop
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを起動する'
  task :start_type01 do
    vpc = CFM::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).start
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットのVPC環境にEC2インスタンスを再起動する'
  task :reboot_type01 do
    vpc = CFM::OneAzOnePublicSubnetVpc.new
    EC2::Ec2.new(vpc).reboot
  end

  desc '１つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type02 do
    vpc = CFM::OneAzTwoPublicSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '１つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type02_env do
    vpc = CFM::OneAzTwoPublicSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type03 do
    vpc = CFM::OneAzTwoPublicAndPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '１つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type03_env do
    vpc = CFM::OneAzTwoPublicAndPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type04 do
    vpc = CFM::TwoAzTwoPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに２つのプライベートサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type04_env do
    vpc = CFM::TwoAzTwoPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type05 do
    vpc = CFM::TwoAzTwoPublicSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type05_env do
    vpc = CFM::TwoAzTwoPublicSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type06 do
    vpc = CFM::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに１つのパブリックサブネットと１つのプライベートサブネットのVPC環境のEC2インスタンスを削除する'
  task :destroy_type06_env do
    vpc = CFM::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットのVPC環境にEC2インスタンスを作成する'
  task :create_type07 do
    vpc = CFM::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
    vpc.create
    EC2::Ec2.new(vpc).create
  end

  desc '２つのアベイラビリティゾーンに２つのパブリックサブネットと２つのプライベートサブネットVPCのVPC環境のEC2インスタンスを削除する'
  task :destroy_type07_env do
    vpc = CFM::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
    EC2::Ec2.new(vpc).destroy
    vpc.destroy
  end


  desc 'キーペアを作成する'
  task :create_key_pair do
    ec2 = EC2::Ec2.new
    key_pair = EC2::KeyPair.new(ec2)
    key_pair.create
  end

  desc 'キーペアを削除する'
  task :delete_key_pair do
    ec2 = EC2::Ec2.new
    key_pair = EC2::KeyPair.new(ec2)
    key_pair.delete
  end

  desc '作成したキーペアをコピーする'
  task :copy_key_pair do
    yaml = YAML.load_file('aws_config.yml')
    key_pair_name = yaml['DEV']['EC2']['KEY_PAIR_NAME']
    path = Dir.pwd + yaml['DEV']['EC2']['KEY_PAIR_PATH']
    pem_file = path + "#{key_pair_name}.pem"
    FileUtils.cp(pem_file,Dir.pwd)
  end
end


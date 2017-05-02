require 'spec_helper'
include VpcSpecHelper

RSpec.describe EC2::Ec2 do
  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    before(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(1)).create
    end

    after(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(1)).destroy
    end

    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(1)) }
    describe '#create' do
      it 'crate security group and keypair' do
        EC2::Ec2.new(vpc).create
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        EC2::Ec2.new(vpc).destroy
      end
    end
  end

  context 'One Availability Zones Two PublicSubnet Virtual private cloud' do
    before(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(2)).create
    end

    after(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(2)).destroy
    end

    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(2)) }
    describe '#create' do
      it 'crate security group and keypair' do
        EC2::Ec2.new(vpc).create
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        EC2::Ec2.new(vpc).destroy
      end
    end
  end

  context 'One Availability Zones One PublicSubnet One PrivateSubnet Virtual private cloud' do
    before(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(3)).create
    end

    after(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(3)).destroy
    end

    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(3)) }
    describe '#create' do
      it 'crate security group and keypair' do
        EC2::Ec2.new(vpc).create
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        EC2::Ec2.new(vpc).destroy
      end
    end
  end

  context 'Two Availability Zones One PublicSubnet and PrivateSubnet Virtual private cloud' do
    before(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(6)).create
    end

    after(:all) do
      create_vpc_instance(VPC::Vpc::TYPE.fetch(6)).destroy
    end

    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(6)) }
    describe '#create' do
      it 'crate security group and keypair' do
        EC2::Ec2.new(vpc).create
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        EC2::Ec2.new(vpc).destroy
      end
    end
  end
end
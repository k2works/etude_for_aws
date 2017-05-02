require 'spec_helper'
include VpcSpecHelper

RSpec.describe EC2::Ec2 do
  SERVICE_STUB = true

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
        create_ec2_instance(vpc)
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        destroy_ec2_instance(vpc)
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
        create_ec2_instance(vpc)
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        destroy_ec2_instance(vpc)
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
        create_ec2_instance(vpc)
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        destroy_ec2_instance(vpc)
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
        create_ec2_instance(vpc)
      end
    end

    describe '#destroy' do
      it 'delete security group and keypair' do
        destroy_ec2_instance(vpc)
      end
    end
  end
end

def create_ec2_instance(vpc)
  if SERVICE_STUB
    EC2::Ec2Stub.new(vpc).create
  else
    EC2::Ec2.new(vpc).create
  end
end

def destroy_ec2_instance(vpc)
  if SERVICE_STUB
    EC2::Ec2Stub.new(vpc).destroy
  else
    EC2::Ec2.new(vpc).destroy
  end
end

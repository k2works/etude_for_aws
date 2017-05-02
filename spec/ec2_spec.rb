require 'spec_helper'
include VpcSpecHelper

RSpec.describe EC2::Ec2 do
  SERVICE_STUB = true

  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    before(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(1),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(1),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(1),SERVICE_STUB) }
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
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(2),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(2),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(2),SERVICE_STUB) }
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
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(3),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(3),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(3),SERVICE_STUB) }
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

  context 'Two Availability Zones Two PrivateSubnet Virtual private cloud' do
    before(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(4),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(4),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(4),SERVICE_STUB) }
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

  context 'Two Availability Zones Two PublicSubnet Virtual private cloud' do
    before(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(5),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(5),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(5),SERVICE_STUB) }
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
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(6),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(6),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(6),SERVICE_STUB) }
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

  context 'Two Availability Zones Two PublicSubnet and PrivateSubnet Virtual private cloud' do
    before(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(7),SERVICE_STUB).create
    end

    after(:all) do
      setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(7),SERVICE_STUB).destroy
    end

    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(7),SERVICE_STUB) }
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

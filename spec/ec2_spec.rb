require 'spec_helper'

RSpec.describe EC2::Ec2 do
  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    before(:all) do
      VPC::OneAzOnePublicSubnetVpc.new.create
    end

    after(:all) do
      VPC::OneAzOnePublicSubnetVpc.new.destroy
    end

    let(:vpc) { VPC::OneAzOnePublicSubnetVpc.new }
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
      VPC::OneAzTwoPublicSubnetVpc.new.create
    end

    after(:all) do
      VPC::OneAzTwoPublicSubnetVpc.new.destroy
    end

    let(:vpc) { VPC::OneAzTwoPublicSubnetVpc.new }
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
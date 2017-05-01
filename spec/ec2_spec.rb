require 'spec_helper'
RSpec.describe EC2::Ec2 do
  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
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
end
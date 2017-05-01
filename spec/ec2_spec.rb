require 'spec_helper'
RSpec.describe EC2::Ec2 do
  describe '.create' do
    it 'crate security group and keypair' do
      EC2::Ec2.create
    end
  end

  describe '.destroy' do
    it 'delete security group and keypair' do
      EC2::Ec2.destroy
    end
  end
end
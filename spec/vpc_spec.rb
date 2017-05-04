require "spec_helper"
include CfmVpcSpecHelper

RSpec.describe VPC::SimpleVpc do
  describe '#create' do
    let(:vpc) {VPC::SimpleVpc.new}

    after(:each) do
      vpc.destroy
    end
    it 'vpc,subnet,internet_gateway,route_table' do
      vpc.create
      expect(vpc.vpc_id).not_to be_nil
      expect(vpc.subnet_id).not_to be_nil
      expect(vpc.internet_gateway_id).not_to be_nil
      expect(vpc.route_table_id).not_to be_nil
    end
  end

  describe '#destroy' do
    let(:vpc) {VPC::SimpleVpc.new}

    context 'Vpc exist' do
      before(:each) do
        vpc.create
      end

      it 'vpc,subnet,internet_gateway,route_table' do
        vpc.destroy
        expect(vpc.vpc_id).to be_empty
        expect(vpc.subnet_id).to be_empty
        expect(vpc.internet_gateway_id).to be_empty
        expect(vpc.route_table_id).to be_empty
      end
    end

    context 'Vpc is not exist' do
      it 'vpc,subnet,internet_gateway,route_table when vpc is not exist' do
        expect{vpc.destroy}.not_to raise_error
      end
    end
  end
end

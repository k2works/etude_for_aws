require "spec_helper"

RSpec.describe VPC::SimpleVpc do
  describe '#create' do
    let(:vpc) {VPC::SimpleVpcStub.new}

    before(:each) do
      vpc.create
    end

    after(:each) do
      vpc.destroy
    end
    it 'vpc' do
      expect(vpc.vpc_id).not_to be_nil
    end

    it 'subnet' do
      expect(vpc.subnet_id).not_to be_nil
    end

    it 'internet_gateway' do
      expect(vpc.internet_gateway_id).not_to be_nil
    end

    it 'route_table' do
      expect(vpc.route_table_id).not_to be_nil
    end
  end

  describe '#destroy' do
    let(:vpc) {VPC::SimpleVpcStub.new}

    context 'Vpc exist' do
      before(:each) do
        vpc.create
      end

      it 'vpc' do
        vpc.destroy
        expect(vpc.vpc_id).to be_empty
      end

      it 'subnet' do
        vpc.destroy
        expect(vpc.subnet_id).to be_empty
      end

      it 'internet_gateway' do
        vpc.destroy
        expect(vpc.internet_gateway_id).to be_empty
      end

      it 'route_table' do
        vpc.destroy
        expect(vpc.route_table_id).to be_empty
      end
    end

    context 'Vpc is not exist' do
      it 'not rise exception' do
        expect{vpc.destroy}.not_to raise_error
      end
    end
  end
end

RSpec.describe VPC::Vpc do
  describe '#create' do
    let(:vpc) {VPC::VpcStub.new}

    before(:each) do
      vpc.create
    end

    after(:each) do
      vpc.destroy
    end
    it 'vpc' do
      expect(vpc.vpc_id).not_to be_nil
    end

    it 'subnet' do
      expect(vpc.subnet_id).not_to be_nil
    end

    it 'internet_gateway' do
      expect(vpc.internet_gateway_id).not_to be_nil
    end

    it 'route_table' do
      expect(vpc.route_table_id).not_to be_nil
    end
  end

  describe '#destroy' do
    let(:vpc) {VPC::VpcStub.new}

    context 'Vpc exist' do
      before(:each) do
        vpc.create
      end

      it 'vpc' do
        vpc.destroy
        expect(vpc.vpc_id).to be_empty
      end

      it 'subnet' do
        vpc.destroy
        expect(vpc.subnet_id).to be_empty
      end

      it 'internet_gateway' do
        vpc.destroy
        expect(vpc.internet_gateway_id).to be_empty
      end

      it 'route_table' do
        vpc.destroy
        expect(vpc.route_table_id).to be_empty
      end
    end

    context 'Vpc is not exist' do
      it 'not rise exception' do
        expect{vpc.destroy}.not_to raise_error
      end
    end
  end
end

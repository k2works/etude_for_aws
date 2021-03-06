require "spec_helper"

RSpec.describe VPC::SimpleVpc do
  describe '#create' do
    let(:vpc_builder) {VPC::VpcDirector.new(VPC::SimpleVpcStub.new)}

    before(:each) do
      vpc_builder.create
    end

    after(:each) do
      vpc_builder.destroy
    end
    it 'vpc' do
      vpc = vpc_builder.builder
      expect(vpc.vpc_id).not_to be_nil
      expect(vpc.config.vpc_name).to eq('TestVpc')
    end

    it 'subnet' do
      vpc = vpc_builder.builder
      expect(vpc.subnets).not_to be_nil
    end

    it 'internet_gateway' do
      vpc = vpc_builder.builder
      expect(vpc.internet_gateway).not_to be_nil
    end

    it 'route_table' do
      vpc = vpc_builder.builder
      expect(vpc.route_tables).not_to be_nil
    end
  end

  describe '#destroy' do
    let(:vpc_builder) {VPC::VpcDirector.new(VPC::SimpleVpcStub.new)}

    context 'Vpc exist' do
      before(:each) do
        vpc_builder.create
      end

      it 'vpc' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.vpc_id).to be_nil
      end

      it 'subnet' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.subnets).to be_empty
      end

      it 'internet_gateway' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.internet_gateway).to be_nil
      end

      it 'route_table' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.route_tables).to be_empty
      end
    end

    context 'Vpc is not exist' do
      it 'not rise exception' do
        expect{vpc_builder.destroy}.not_to raise_error
      end
    end
  end
end

RSpec.describe VPC::StandardVpc do
  describe '#create' do
    let(:vpc_builder) {VPC::VpcDirector.new(VPC::StandardVpcStub.new)}

    before(:each) do
      vpc_builder.create
    end

    after(:each) do
      vpc_builder.destroy
    end
    it 'vpc' do
      vpc = vpc_builder.builder
      expect(vpc.vpc_id).not_to be_nil
    end

    it 'subnet' do
      vpc = vpc_builder.builder
      expect(vpc.subnets).not_to be_nil
      expect(vpc.private_subnets).not_to be_nil
      expect(vpc.public_subnets).not_to be_nil
    end

    it 'internet_gateway' do
      vpc = vpc_builder.builder
      expect(vpc.internet_gateway).not_to be_nil
    end

    it 'route_table' do
      vpc = vpc_builder.builder
      expect(vpc.route_tables).not_to be_nil
      expect(vpc.private_route_tables).not_to be_nil
      expect(vpc.public_route_tables).not_to be_nil
    end
  end

  describe '#destroy' do
    let(:vpc_builder) {VPC::VpcDirector.new(VPC::StandardVpcStub.new)}

    context 'Vpc exist' do
      before(:each) do
        vpc_builder.create
      end

      it 'vpc' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.vpc_id).to be_nil
      end

      it 'subnet' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.subnets).to be_empty
        expect(vpc.private_subnets).to be_empty
        expect(vpc.public_subnets).to be_empty
      end

      it 'internet_gateway' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.internet_gateway).to be_nil
      end

      it 'route_table' do
        vpc_builder.destroy
        vpc = vpc_builder.builder
        expect(vpc.route_tables).to be_empty
        expect(vpc.private_route_tables).to be_empty
        expect(vpc.public_route_tables).to be_empty
      end
    end

    context 'Vpc is not exist' do
      it 'not rise exception' do
        expect{vpc_builder.destroy}.not_to raise_error
      end
    end
  end
end

def create_vpn
  vpc = vpc_builder.builder
  vpn_builder = VPC::VpnDirector.new(VPC::VpnStub.new(vpc))
  vpn_builder.create
  vpn_builder.builder
end

def destroy_vpn
  vpc = vpc_builder.builder
  vpn_builder = VPC::VpnDirector.new(VPC::VpnStub.new(vpc))
  vpn_builder.create
  vpn_builder.destroy
  vpn_builder.builder
end

RSpec.describe VPC::Vpn do
  describe '#create' do
    let(:vpc_builder) {VPC::VpcDirector.new(VPC::StandardVpcStub.new)}

    before(:each) do
      vpc_builder.create
    end

    after(:each) do
      vpc_builder.destroy
    end

    it 'customer gateway' do
      vpn = create_vpn
      expect(vpn.customer_gateways).not_to be_empty
    end

    it 'vpn gateway' do
      vpn = create_vpn
      expect(vpn.vpn_gateway).not_to be_nil
    end

    it 'vpn connection' do
      vpn = create_vpn
      expect(vpn.vpn_connections).not_to be_empty
    end

    it 'route to internet vpn' do
      vpn = create_vpn
      expect(vpn.vpc.route_tables).not_to be_nil
    end
  end

  describe '#destroy' do
    let(:vpc_builder) {VPC::VpcDirector.new(VPC::StandardVpcStub.new)}

    before(:each) do
      vpc_builder.create
    end

    it 'customer gateway' do
      vpn = destroy_vpn
      expect(vpn.customer_gateways.first.to_s).to eq('#<struct Aws::EmptyStructure>')
    end

    it 'vpn gateway' do
      vpn = destroy_vpn
      expect(vpn.vpn_gateway.to_s).to eq('#<struct Aws::EmptyStructure>')
    end

    it 'vpn connection' do
      vpn = destroy_vpn
      expect(vpn.vpn_connections.first.to_s).to eq('#<struct Aws::EmptyStructure>')
    end

    it 'route to internet vpn' do
      vpn = destroy_vpn
      expect(vpn.route_tables).to be_empty
    end

  end
end
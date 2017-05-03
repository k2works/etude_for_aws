require "spec_helper"
include VpcSpecHelper

RSpec.describe VPC::Vpc do
  SERVICE_STUB = true

  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(1),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'One Availability Zones Two PublicSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(2),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'One Availability Zones One PublicSubnet One PrivateSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(3),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'Two Availability Zones Two PrivateSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(4),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'Two Availability Zones Two PublicSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(5),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'Two Availability Zones One PublicSubnet and PrivateSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(6),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'Two Availability Zones Two PublicSubnet and PrivateSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(VPC::Vpc::TYPE.fetch(7),SERVICE_STUB) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'Exception' do
    let(:vpc) { setup_create_vpc_instance(:NOT_DEFINE,SERVICE_STUB) }
    describe '#create' do
      it 'do noting' do
        vpc.create
        expect(vpc.config.stack_id).to be_nil
      end
    end

    describe '#destroy' do
      it 'do nothing' do
        vpc.destroy
        expect(vpc.config.stack_id).to be_nil
      end
    end
  end

  def check_create(vpc)
      vpc.create
      expect(vpc.config.stack_id).not_to be_nil
  end

  def check_destroy(vpc)
      vpc.destroy
      expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      expect(vpc.config.vpc_id).to be_nil
  end
end

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

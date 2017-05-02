require "spec_helper"
include VpcSpecHelper

RSpec.describe VPC::Vpc do
  EXECUTE = false

  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(1)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        check_create(vpc)
      end
    end

    describe '#set_vpc_id' do
      it 'has vpc id' do
        if EXECUTE
          sleep(5)
          vpc.set_vpc_id
          expect(vpc.config.vpc_id).not_to be_nil
        end
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        check_destroy(vpc)
      end
    end
  end

  context 'One Availability Zones Two PublicSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(2)) }
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
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(3)) }
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
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(4)) }
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
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(5)) }
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
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(6)) }
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
    let(:vpc) { create_vpc_instance(VPC::Vpc::TYPE.fetch(7)) }
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
    let(:vpc) { create_vpc_instance(:NOT_DEFINE) }
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
    if EXECUTE
      vpc.create
      expect(vpc.config.stack_id).not_to be_nil
    end
  end

  def check_destroy(vpc)
    if EXECUTE
      vpc.destroy
      expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      expect(vpc.config.vpc_id).to be_nil
    end
  end
end
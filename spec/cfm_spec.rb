require "spec_helper"
include CfmVpcSpecHelper

RSpec.describe CFM::Vpc do
  SERVICE_STUB = true

  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(1),SERVICE_STUB) }
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
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(2),SERVICE_STUB) }
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
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(3),SERVICE_STUB) }
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
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(4),SERVICE_STUB) }
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
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(5),SERVICE_STUB) }
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
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(6),SERVICE_STUB) }
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
    let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(7),SERVICE_STUB) }
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

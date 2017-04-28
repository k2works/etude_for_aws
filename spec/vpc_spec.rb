require "spec_helper"

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
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to be_nil
      end
    end
  end

  def create_vpc_instance(type)
    case type
      when :ONE_AZ_ONE_PUB
        return VPC::OneAzOnePublicSubnetVpc.new
      when :ONE_AZ_TWO_PUB
        return VPC::OneAzTwoPublicSubnetVpc.new
      when :ONE_AZ_ONE_PUB_PRI
        return VPC::OneAzTwoPublicAndPrivateSubnetVpc.new
      when :TWO_AZ_TWO_PRI
        return VPC::TwoAzTwoPrivateSubnetVpc.new
      when :TWO_AZ_TWO_PUB
        return VPC::TwoAzTwoPublicSubnetVpc.new
      when :TWO_AZ_ONE_PUB_RPI
        return VPC::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
      when :TWO_AZ_TWO_PUB_PRI
        return VPC::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
      else
        return VPC::NullVpc.new
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
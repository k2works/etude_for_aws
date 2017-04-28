require "spec_helper"

RSpec.describe Vpc do
  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(1)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end

  context 'One Availability Zones Two PublicSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(2)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end

  context 'One Availability Zones One PublicSubnet One PrivateSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(3)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end

  context 'Two Availability Zones Two PrivateSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(4)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end

  context 'Two Availability Zones Two PublicSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(5)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end

  context 'Two Availability Zones One PublicSubnet and PrivateSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(6)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end

  context 'Two Availability Zones Two PublicSubnet and PrivateSubnet Virtual private cloud' do
    let(:vpc) { create_vpc_instance(Vpc::TYPE.fetch(7)) }
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end
end

def create_vpc_instance(type)
  case type
    when :ONE_AZ_ONE_PUB
      return OneAzOnePublicSubnetVpc.new
    when :ONE_AZ_TWO_PUB
      return OneAzTwoPublicSubnetVpc.new
    when :ONE_AZ_ONE_PUB_PRI
      return OneAzTwoPublicAndPrivateSubnetVpc.new
    when :TWO_AZ_TWO_PRI
      return TwoAzTwoPrivateSubnetVpc.new
    when :TWO_AZ_TWO_PUB
      return TwoAzTwoPublicSubnetVpc.new
    when :TWO_AZ_ONE_PUB_RPI
      return TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
    when :TWO_AZ_TWO_PUB_PRI
      return TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
    else
      raise
  end
end

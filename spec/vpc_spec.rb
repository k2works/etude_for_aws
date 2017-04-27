require "spec_helper"

RSpec.describe Vpc do
  context 'One Availability Zones One PublicSubnet Virtual private cloud' do
    describe '#create' do
      it 'create vpc using cloud formation' do
        vpc = OneAzOnePublicSubnetVpc.new
        vpc.create
        expect(vpc.config.stack_id).not_to be_nil
      end
    end

    describe '#destroy' do
      it 'destroy vpc using cloud formation' do
        vpc = OneAzOnePublicSubnetVpc.new
        vpc.destroy
        expect(vpc.config.stack_id).to eq('Aws::EmptyStructure')
      end
    end
  end
end

require "spec_helper"

RSpec.describe Vpc do
  describe '.create' do
    it "create vpc using cloud formation" do
      expect(Vpc.create).to include('arn:aws:cloudformation:')
    end
  end

  describe '.destroy' do
    it "destroy vpc using cloud formation" do
      expect(Vpc.destroy).to eq('Aws::EmptyStructure')
    end
  end
end

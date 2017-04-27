require "spec_helper"

RSpec.describe Vpc do
  describe '.create' do
    it "create vpc using cloud formation" do
      config = Vpc.create
      expect(config.stack_id).not_to be_nil
    end
  end

  describe '.destroy' do
    it "destroy vpc using cloud formation" do
      config = Vpc.destroy
      expect(config.stack_id).to eq('Aws::EmptyStructure')
    end
  end
end

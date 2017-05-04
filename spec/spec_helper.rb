require "bundler/setup"
require "etude_for_aws"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module CfmVpcSpecHelper
  def create_vpc_instance(type)
    case type
      when :ONE_AZ_ONE_PUB
        return CFM::OneAzOnePublicSubnetVpc.new
      when :ONE_AZ_TWO_PUB
        return CFM::OneAzTwoPublicSubnetVpc.new
      when :ONE_AZ_ONE_PUB_PRI
        return CFM::OneAzTwoPublicAndPrivateSubnetVpc.new
      when :TWO_AZ_TWO_PRI
        return CFM::TwoAzTwoPrivateSubnetVpc.new
      when :TWO_AZ_TWO_PUB
        return CFM::TwoAzTwoPublicSubnetVpc.new
      when :TWO_AZ_ONE_PUB_RPI
        return CFM::TwoAzOnePublicSubnetAndPrivateSubnetVpc.new
      when :TWO_AZ_TWO_PUB_PRI
        return CFM::TwoAzTwoPublicSubnetAndPrivateSubnetVpc.new
      else
        return CFM::NullVpc.new
    end
  end

  def create_vpc_instance_stub(type)
    case type
      when :ONE_AZ_ONE_PUB
        return CFM::OneAzOnePublicSubnetVpcStub.new
      when :ONE_AZ_TWO_PUB
        return CFM::OneAzTwoPublicSubnetVpcStub.new
      when :ONE_AZ_ONE_PUB_PRI
        return CFM::OneAzTwoPublicAndPrivateSubnetVpcStub.new
      when :TWO_AZ_TWO_PRI
        return CFM::TwoAzTwoPrivateSubnetVpcStub.new
      when :TWO_AZ_TWO_PUB
        return CFM::TwoAzTwoPublicSubnetVpcStub.new
      when :TWO_AZ_ONE_PUB_RPI
        return CFM::TwoAzOnePublicSubnetAndPrivateSubnetVpcStub.new
      when :TWO_AZ_TWO_PUB_PRI
        return CFM::TwoAzTwoPublicSubnetAndPrivateSubnetVpcStub.new
      else
        return CFM::NullVpc.new
    end
  end

  def setup_create_vpc_instance(type,stub)
    if stub
      create_vpc_instance_stub(type)
    else
      create_vpc_instance(type)
    end
  end
end

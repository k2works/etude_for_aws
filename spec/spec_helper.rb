require "bundler/setup"
require "etude_for_aws"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module VpcSpecHelper
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
end

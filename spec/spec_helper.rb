require 'bundler/setup'
require 'etude_for_aws'
require 'helpers/cfm_vpc_spec_helper'
require 'helpers/ec2_spec_helper'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
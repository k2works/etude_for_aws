#!/usr/bin/env ruby

require "bundler/setup"
require "etude_for_aws"

Dotenv.load
system("export AWS_ACCESS_KEY_ID=#{ENV['AWS_ACCESS_KEY_ID']}")
system("export AWS_SECRET_ACCESS_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']}")
system("export AWS_DEFAULT_REGION=#{ENV['AWS_DEFAULT_REGION']}")
system("aws.rb")

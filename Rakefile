require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
YARD::Rake::YardocTask.new

load 'lib/etude_for_aws/tasks/ec2.rake'
load 'lib/etude_for_aws/tasks/vpc.rake'
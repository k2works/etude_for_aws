require 'aws-sdk'
require 'dotenv'
require 'json'

class Vpc
  def self.create
    config = Configuration.new
    cfm = Aws::CloudFormation::Client.new
    stack_names = []
    cfm.describe_stacks.stacks.each do |stack|
      stack_names << stack.stack_name
    end
    unless stack_names.include?(config.stack_name)
      resp = cfm.create_stack({
                                  stack_name: config.stack_name,
                                  template_body: config.template,
                                  tags: [
                                      {
                                          key: 'Name',
                                          value: config.stack_tag_value,
                                      },
                                  ],
                              })
      config.stack_id = resp.stack_id
    end
    config
  end

  def self.destroy
    config = Configuration.new
    cfm = Aws::CloudFormation::Client.new
    stack_names = []
    cfm.describe_stacks.stacks.each do |stack|
      stack_names << stack.stack_name
    end
    if stack_names.include?(config.stack_name)
      resp = cfm.delete_stack({
                                  stack_name: config.stack_name,
                              })
      config.stack_id = resp.to_s
    end
    config
  end
end

class Configuration
  attr_reader :stack_name,:file,:template,:stack_tag_value
  attr_accessor :stack_id

  def initialize
    Dotenv.load
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_DEFAULT_REGION']
    )
    @stack_name = 'VPCtestStack'
    template_path = '/lib/etude_for_aws/vpc/cfm_templates/'
    template_file = 'vpc-1az-1subnet-pub.template'
    @file = Dir.pwd + template_path + template_file
    @template = File.read(file)
    @stack_tag_value = 'test'
  end
end
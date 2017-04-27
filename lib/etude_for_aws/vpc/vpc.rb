require 'aws-sdk'
require 'dotenv'

class Vpc
  attr_reader :config

  def initialize
    @config = Configuration.new
    @cfm = Aws::CloudFormation::Client.new
  end

  def create
    stack_names = collect_stack_name
    unless stack_names.include?(@config.stack_name)
      resp = @cfm.create_stack({
                                  stack_name: @config.stack_name,
                                  template_body: @config.template,
                                  tags: [
                                      {
                                          key: 'Name',
                                          value: @config.stack_tag_value,
                                      },
                                  ],
                              })
      @config.stack_id = resp.stack_id
    end
  end

  def destroy
    stack_names = collect_stack_name
    if stack_names.include?(@config.stack_name)
      resp = @cfm.delete_stack({
                                  stack_name: @config.stack_name,
                              })
      @config.stack_id = resp.to_s
    end
  end

  private
  def collect_stack_name
    stack_names = []
    @cfm.describe_stacks.stacks.each do |stack|
      stack_names << stack.stack_name
    end
    stack_names
  end
end

class OneAzOnePublicSubnetVpc < Vpc
  def initialize
    super
    @config.stack_name = 'VPCtestStack'
    template_path = '/lib/etude_for_aws/vpc/cfm_templates/'
    template_file = 'vpc-1az-1subnet-pub.template'
    file = Dir.pwd + template_path + template_file
    @config.template = File.read(file)
    @config.stack_tag_value = 'test'
  end
end

class Configuration
  attr_accessor :stack_name,:template,:stack_tag_value,:stack_id

  def initialize
    Dotenv.load
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_DEFAULT_REGION']
    )
  end
end
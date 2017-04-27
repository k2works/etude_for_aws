require 'aws-sdk'
require 'dotenv'
require 'yaml'

class Vpc
  attr_reader :config

  def initialize
    @config = Configuration.new
    @cfm = Aws::CloudFormation::Client.new
  end

  def create
    unless collect_stack_name.include?(@config.stack_name)
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
    if collect_stack_name.include?(@config.stack_name)
      resp = @cfm.delete_stack({
                                  stack_name: @config.stack_name,
                              })
      @config.stack_id = resp.to_s
    end
  end

  protected
  def get_template_full_path(template_file)
    Dir.pwd + @config.template_path + template_file
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
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_01']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
  end
end

class Configuration
  attr_accessor :stack_name,:template,:stack_tag_value,:stack_id,:yaml,:template_path

  def initialize
    Dotenv.load
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_DEFAULT_REGION']
    )

    @yaml = YAML.load_file('config.yml')
    @stack_name = @yaml['DEV']['VPC']['STACK_NAME']
    @stack_tag_value = @yaml['DEV']['VPC']['TAG_VALUE']
    @template_path = @yaml['DEV']['VPC']['TEMPLATE_PATH']
  end
end
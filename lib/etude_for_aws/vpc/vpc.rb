require 'aws-sdk'
require 'dotenv'
require 'yaml'

class Vpc
  attr_reader :config

  TYPE = {
      1 => :ONE_AZ_ONE_PUB,
      2 => :ONE_AZ_TWO_PUB,
      3 => :ONE_AZ_ONE_PUB_PRI,
      4 => :TWO_AZ_TWO_PRI,
      5 => :TWO_AZ_TWO_PUB,
      6 => :TWO_AZ_ONE_PUB_RPI,
      7 => :TWO_AZ_TWO_PUB_PRI
  }

  def initialize
    @config = Configuration.new
    @cfm = Aws::CloudFormation::Client.new
  end

  def create
    unless collect_stack_name.include?(@config.stack_name)
      resp = @cfm.create_stack({
                                  stack_name: @config.stack_name,
                                  template_body: @config.template,
                                  parameters: @config.parameters,
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
      @config.vpc_id = nil
    end
  end

  def set_vpc_id
    if collect_stack_name.include?(@config.stack_name)
      @config.vpc_id = get_vpc_id
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

  def get_vpc_id
    @cfm.describe_stack_resource({stack_name: @config.stack_name, logical_resource_id: 'VPC'}).stack_resource_detail.physical_resource_id
  end
end

class NullVpc < Vpc
  def initialize
    super
  end

  def create
  end

  def destroy
  end
end

class OneAzOnePublicSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_01']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = []
  end
end

class OneAzTwoPublicSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_02']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = [
        {
            parameter_key: "AZ1",
            parameter_value: @config.azs[0],
            use_previous_value: false,
        },
    ]
  end
end

class OneAzTwoPublicAndPrivateSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_03']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = [
        {
            parameter_key: "AZ1",
            parameter_value: @config.azs[0],
            use_previous_value: false,
        },
    ]
  end
end

class TwoAzTwoPrivateSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_04']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = [
        {
            parameter_key: "AZ1",
            parameter_value: @config.azs[0],
            use_previous_value: false,
        },
        {
            parameter_key: "AZ2",
            parameter_value: @config.azs[1],
            use_previous_value: false,
        },
    ]
  end
end

class TwoAzTwoPublicSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_05']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = [
        {
            parameter_key: "AZ1",
            parameter_value: @config.azs[0],
            use_previous_value: false,
        },
        {
            parameter_key: "AZ2",
            parameter_value: @config.azs[1],
            use_previous_value: false,
        },
    ]
  end
end

class TwoAzOnePublicSubnetAndPrivateSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_06']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = [
        {
            parameter_key: "AZ1",
            parameter_value: @config.azs[0],
            use_previous_value: false,
        },
        {
            parameter_key: "AZ2",
            parameter_value: @config.azs[1],
            use_previous_value: false,
        },
    ]
  end
end

class TwoAzTwoPublicSubnetAndPrivateSubnetVpc < Vpc
  def initialize
    super
    template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_07']
    file = get_template_full_path(template_file)
    @config.template = File.read(file)
    @config.parameters = [
        {
            parameter_key: "AZ1",
            parameter_value: @config.azs[0],
            use_previous_value: false,
        },
        {
            parameter_key: "AZ2",
            parameter_value: @config.azs[1],
            use_previous_value: false,
        },
    ]
  end
end

class Configuration
  attr_accessor :stack_name,:template,:stack_tag_value,:stack_id,:yaml,:template_path,:parameters,:azs,:vpc_id

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
    @azs = []
    @azs << @yaml['DEV']['VPC']['TEMPLATE_PARAMS_AZ1']
    @azs << @yaml['DEV']['VPC']['TEMPLATE_PARAMS_AZ2']
    @azs << @yaml['DEV']['VPC']['TEMPLATE_PARAMS_AZ3']
  end
end
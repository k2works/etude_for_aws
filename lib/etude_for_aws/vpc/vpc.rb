require 'aws-sdk'

module VPC
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
end
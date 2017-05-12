module CFM
  class Vpc
    include EC2::VpcInterface

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
      @cfm = @config.create_client
      set_vpc_id
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
        @cfm.wait_until(:stack_create_complete, {stack_name: @config.stack_name})
        @config.stack_id = resp.stack_id
      end
    end

    def destroy
      if collect_stack_name.include?(@config.stack_name)
        resp = @cfm.delete_stack({
                                     stack_name: @config.stack_name,
                                 })
        @cfm.wait_until(:stack_delete_complete, {stack_name: @config.stack_name})
        @config.stack_id = resp.to_s
        @config.vpc_id = nil
      end
    end

    def get_vpc_id
      @config.vpc_id
    end

    def get_subnet_infos
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

    def select_vpc_id
      @cfm.describe_stack_resource({stack_name: @config.stack_name, logical_resource_id: 'VPC'}).stack_resource_detail.physical_resource_id
    end

    def set_vpc_id
      if collect_stack_name.include?(@config.stack_name)
        @config.vpc_id = get_vpc_id
      end
    end
  end

  class VpcStub < Vpc
    include EC2::VpcInterface

    def initialize
      super
      @config = ConfigurationStub.new
      @cfm = @config.create_client
    end

    def create
      p "#{self.class} Create Virtual Private Cloud"
      @config.stack_id = 'DUMMY'
    end

    def destroy
      p "#{self.class} Destroy Virtual Private Cloud"
      @config.stack_id = 'Aws::EmptyStructure'
      @config.vpc_id = nil
    end
  end
end
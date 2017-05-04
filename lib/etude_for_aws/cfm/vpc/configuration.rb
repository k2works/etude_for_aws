require 'yaml'

module CFM
  class Configuration
    include CertificationHelper

    attr_accessor :stack_name,
                  :template,
                  :stack_tag_value,
                  :stack_id,
                  :yaml,
                  :template_path,
                  :parameters,
                  :azs,
                  :vpc_id

    def initialize
      aws_certificate
      @yaml = YAML.load_file('config.yml')
      @stack_name = @yaml['DEV']['CFM']['VPC']['STACK_NAME']
      @stack_tag_value = @yaml['DEV']['CFM']['VPC']['TAG_VALUE']
      @template_path = @yaml['DEV']['CFM']['VPC']['TEMPLATE_PATH']
      @azs = []
      @azs << @yaml['DEV']['CFM']['VPC']['TEMPLATE_PARAMS_AZ1']
      @azs << @yaml['DEV']['CFM']['VPC']['TEMPLATE_PARAMS_AZ2']
      @azs << @yaml['DEV']['CFM']['VPC']['TEMPLATE_PARAMS_AZ3']
    end
  end
end
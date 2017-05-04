module CFM
  class Configuration
    include CertificationHelper
    include ConfigurationHelper

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
      @yaml = ConfigurationHelper.load_yaml_file
      @stack_name = get_yaml_stack_name
      @stack_tag_value = get_yaml_stack_tag_value
      @template_path = get_yaml_template_path
      @azs = get_yaml_zas
    end

    def get_template_file(type)
      get_yaml_template_file(type)
    end
  end
end
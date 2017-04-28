require 'dotenv'
require 'yaml'

module VPC
  class Configuration
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
end
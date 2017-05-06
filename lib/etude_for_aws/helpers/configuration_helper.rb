require 'yaml'

module ConfigurationHelper
  YAML_FILE = 'config.yml'

  def self.load_yaml_file
    YAML.load_file(YAML_FILE)
  end

  def self.get_yaml_region
    ConfigurationHelper.load_yaml_file['DEV']['REGION']
  end

  def get_yaml_stack_name
    ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['STACK_NAME']
  end

  def get_yaml_stack_tag_value
    ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TAG_VALUE']
  end

  def get_yaml_template_path
    ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_PATH']
  end

  def get_yaml_zas
    azs = []
    azs << ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_PARAMS_AZ1']
    azs << ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_PARAMS_AZ2']
    azs << ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_PARAMS_AZ3']
    azs
  end

  def get_yaml_template_file(type)
    case type
      when :ONE_AZ_ONE_PUB
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_01']
      when :ONE_AZ_TWO_PUB
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_02']
      when :ONE_AZ_ONE_PUB_PRI
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_03']
      when :TWO_AZ_TWO_PRI
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_04']
      when :TWO_AZ_TWO_PUB
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_05']
      when :TWO_AZ_ONE_PUB_RPI
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_06']
      when :TWO_AZ_TWO_PUB_PRI
        return ConfigurationHelper.load_yaml_file['DEV']['CFM']['VPC']['TEMPLATE_FILE_TYPE_07']
      else
        return raise
    end
  end

  def get_yaml_vpc_tags
    ConfigurationHelper.load_yaml_file['DEV']['VPC']['VPC_TAGS']
  end

  def get_yaml_vpc_cidr_block
    ConfigurationHelper.load_yaml_file['DEV']['VPC']['VPC_CIDR_BLOCK']
  end

  def get_yaml_subnet_cidr_block
    ConfigurationHelper.load_yaml_file['DEV']['VPC']['SUBNET_CIDR_BLOCK']
  end

  def get_yaml_subnet_cidr_block_public
    ConfigurationHelper.load_yaml_file['DEV']['VPC']['SUBNET_CIDR_BLOCK_PUBLIC']
  end

  def get_yaml_subnet_cidr_block_private
    ConfigurationHelper.load_yaml_file['DEV']['VPC']['SUBNET_CIDR_BLOCK_PRIVATE']
  end

  def get_yaml_destination_cidr_block
    ConfigurationHelper.load_yaml_file['DEV']['VPC']['DESTINATION_CIDR_BLOCK']
  end
end
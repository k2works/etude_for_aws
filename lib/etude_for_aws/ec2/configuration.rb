module EC2
  class Configuration
    include ConfigurationHelper

    attr_accessor :vpc_id,
                  :subnet_id,
                  :az

    attr_reader :security_group_name,
                :security_group_description,
                :key_pair_name,
                :key_pair_path,
                :image_id,
                :instance_type,
                :min_count,
                :max_count,
                :instance_tags,
                :stub

    def initialize
      ec2_config = get_yaml_ec2_config
      @security_group_name = ec2_config['SECURITY_GROUP_NAME']
      @security_group_description = ec2_config['SECURITY_GROUP_DESCRIPTION']
      @key_pair_name = ec2_config['KEY_PAIR_NAME']
      @key_pair_path = ec2_config['KEY_PAIR_PATH']
      @image_id = ec2_config['IMAGE_ID']
      @instance_type = ec2_config['INSTANCE_TYPE']
      @min_count = ec2_config['MIN_COUNT'].to_i
      @max_count = ec2_config['MAX_COUNT'].to_i
      name_value = ec2_config['INSTANCE_TAGS']['NAME_VALUE']
      group_value = ec2_config['INSTANCE_TAGS']['GROUP_VALUE']
      @instance_tags = [{key: 'Name', value: name_value}, {key: 'Group', value: group_value}]
      @stub = false
    end

    def stub?
      @stub
    end
  end

  class ConfigurationStub < Configuration
    def initialize
      super
      @stub = true
    end
  end
end
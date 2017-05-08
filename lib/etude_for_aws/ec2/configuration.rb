module EC2
  class Configuration
    include ConfigurationHelper

    attr_accessor :vpc_id,
                  :subnet_id,
                  :az

    attr_reader :client,
                :ec2,
                :yaml,
                :stub

    def initialize
      @yaml = YAML.load_file('config.yml')
      @stub = false
    end

    def stub?
      @stub == true
    end
  end

  class ConfigurationStub < Configuration
    def initialize
      super
      @stub = true
    end
  end
end
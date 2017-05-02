module EC2
  class Configuration
    include CertificationHelper

    attr_accessor :vpc_id,
                  :subnet_id,
                  :az

    attr_reader :client,
                :ec2,
                :yaml

    def initialize
      aws_certificate

      @yaml = YAML.load_file('config.yml')
      @client = Aws::EC2::Client.new
      @ec2 = Aws::EC2::Resource.new(client: client)
    end
  end
end
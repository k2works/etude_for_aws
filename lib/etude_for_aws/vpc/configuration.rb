module VPC
  class Configuration
    include CertificationHelper
    include ConfigurationHelper

    attr_reader :vpc_cidr_block,
                :subnet_cidr_block,
                :destination_cidr_block,
                :tags,
                :filter_tag_value,
                :ec2

    def initialize
      aws_certificate

      @vpc_cidr_block = '10.0.0.0/16'
      @subnet_cidr_block = '10.0.0.0/24'
      @destination_cidr_block = '0.0.0.0/0'
      tag_value = 'TestVpc'
      @tags = [{key: 'Name', value: tag_value}]
      @filter_tag_value = {name: 'tag-value', values: [tag_value]}
      @ec2 = Aws::EC2::Client.new
    end
  end

  class ConfigurationStub < Configuration
    def initialize
      super
      @ec2 = Aws::EC2::Client.new(stub_responses: true)
    end
  end
end

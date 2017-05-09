require 'aws-sdk'
require 'dotenv'

module CertificationHelper
  def aws_certificate
    Dotenv.load
    yaml_region = ConfigurationHelper.get_yaml_region
    region = ENV['AWS_REGION']
    region = yaml_region if region.nil?
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: region
    )
  end
end
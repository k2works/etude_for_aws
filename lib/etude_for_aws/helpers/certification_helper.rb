require 'dotenv'
require 'yaml'

module CertificationHelper
  def aws_certificate
    Dotenv.load
    yaml = YAML.load_file('config.yml')

    region = ENV['AWS_REGION']
    region = yaml['DEV']['REGION'] if region.nil?
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: region
    )
  end
end
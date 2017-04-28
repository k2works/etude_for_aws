require 'dotenv'

module CertificationHelper
  def aws_certificate
    Dotenv.load
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_DEFAULT_REGION']
    )
  end
end
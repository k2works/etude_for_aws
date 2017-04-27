require 'aws-sdk'
require 'dotenv'
require 'json'

class Vpc
  def self.create
    Dotenv.load
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_DEFAULT_REGION']
    )
    file = Dir.pwd + '/lib/etude_for_aws/vpc/cfm_templates/vpc-1az-1subnet-pub.template'
    template = File.read(file)
    cfm = Aws::CloudFormation::Client.new
    stack_names = []
    cfm.describe_stacks.stacks.each do |stack|
      stack_names << stack.stack_name
    end
    if stack_names.include?('VPCtestStack') == false
      resp = cfm.create_stack({
                           stack_name: 'VPCtestStack',
                           template_body: template,
                           tags:[
                               {
                                   key:'Name',
                                   value:'test',
                               },
                           ],
                       })
      return resp.to_s
    end
  end

  def self.destroy
    Dotenv.load
    Aws.config.update(
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: ENV['AWS_DEFAULT_REGION']
    )
    cfm = Aws::CloudFormation::Client.new
    stack_names = []
    cfm.describe_stacks.stacks.each do |stack|
      stack_names << stack.stack_name
    end
    if stack_names.include?('VPCtestStack') == true
      resp = cfm.delete_stack({
                                  stack_name: 'VPCtestStack',
                              })
      return resp.to_s
    end
  end
end
module EC2
  class Ec2ApiGateway
    include CertificationHelper

    attr_reader :client,:resource

    def initialize
      aws_certificate
      @client = Aws::EC2::Client.new
      @resource = Aws::EC2::Resource.new(client: client)
    end

  end

  class Ec2ApiGatewayStub < Ec2ApiGateway
    def initialize
      @client = Aws::EC2::Client.new(stub_responses: true)
      @resource = Aws::EC2::Resource.new(stub_responses: true,client: client)
    end
  end
end
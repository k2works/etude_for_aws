module VPC
  class SimpleVpc < Vpc
    def initialize
      super
    end
  end

  class SimpleVpcStub < SimpleVpc
    def initialize
      super
      @config = VPC::ConfigurationStub.new
      @gateway = VPC::VpcApiGatewayStub.new
    end
  end
end

module VPC
  class OneAzOnePublicSubnetVpc < Vpc
    def initialize
      super
      template_file = @config.yaml['DEV']['VPC']['TEMPLATE_FILE_TYPE_01']
      file = get_template_full_path(template_file)
      @config.template = File.read(file)
      @config.parameters = []
    end
  end
end
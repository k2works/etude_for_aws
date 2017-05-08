module EC2
  class SecurityGroup
    attr_accessor :security_group_id

    def initialize(ec2)
      @config = ec2.config
      @gateway = ec2.gateway
      group_name = @config.security_group_name
      description = @config.security_group_description
      vpc_id = @config.vpc_id
      @security_group = {
          group_name: group_name,
          description: description,
          vpc_id: vpc_id,
      }
      @authorize_egress = {
          ip_permissions: [
              {
                  ip_protocol: "tcp",
                  from_port: 22,
                  to_port: 22,
                  ip_ranges: [
                      {
                          cidr_ip: "0.0.0.0/0",
                      },
                  ],
              },
          ],
      }
      @authorize_ingress = {
          ip_permissions: [
              {
                  ip_protocol: "tcp",
                  from_port: 22,
                  to_port: 22,
                  ip_ranges: [
                      {
                          cidr_ip: "0.0.0.0/0",
                      },
                  ],
              },
          ],
      }
      @security_group_id = get_group_id
    end

    def create
      if @security_group_id.nil?
        id = @gateway.create_security_group(@security_group)
        @gateway.authorize_egress(id,@authorize_egress)
        @gateway.authorize_ingress(id,@authorize_ingress)
        @security_group_id = id
      end
    end

    def delete
      @gateway.delete_security_group(@security_group_id) unless @security_group_id.nil?
    end

    private
    def get_group_id
      @gateway.get_group_id(@security_group)
    end
  end
end
module EC2
  class SecurityGroup
    attr_accessor :security_group_id

    def initialize(ec2)
      @config = ec2.config
      @gateway = ec2.gateway
      group_name = @config.yaml['DEV']['EC2']['SECURITY_GROUP_NAME']
      description = @config.yaml['DEV']['EC2']['SECURITY_GROUP_DESCRIPTION']
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
        sg = @gateway.resource.create_security_group(@security_group)

        sg.authorize_egress(@authorize_egress)
        sg.authorize_ingress(@authorize_ingress)
        @security_group_id = sg.id
      end
    end

    def delete
      resp = nil
      unless @security_group_id.nil?
        resp = @gateway.client.delete_security_group({
                                                        group_id: @security_group_id,
                                                    })
      end
      resp
    end

    private
    def get_group_id
      group_id = nil
      @gateway.resource.security_groups.each do |sg|
        if sg.group_name == @security_group[:group_name]
          group_id = sg.group_id
        end
      end
      group_id
    end
  end
end
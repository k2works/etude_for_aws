module EC2
  class Ec2ApiGateway
    include CertificationHelper

    attr_reader :client,:resource,:stub

    def initialize
      aws_certificate
      @client = Aws::EC2::Client.new
      @resource = Aws::EC2::Resource.new(client: client)
      @stub = false
    end

    def stub?
      @stub
    end

    def get_instance_collection(values)
      instance_ids = []
      resp = @client.describe_instances(filters: [{name: "tag:Name", values: values}])
      resp.reservations.each do |reservation|
        reservation.instances.each do |instance|
          instance_ids << instance.instance_id
        end
      end
      instance_ids
    end

    def get_group_id(security_group)
      group_id = nil
      @resource.security_groups.each do |sg|
        if sg.group_name == security_group[:group_name]
          group_id = sg.group_id
        end
      end
      group_id
    end

    def select_key_pairs
      @client.describe_key_pairs
    end

    def find_instance_by_id(instance_id)
      @resource.instance(instance_id)
    end

    def create_security_group(security_group)
      resp = @resource.create_security_group(security_group)
      resp.id
    end

    def authorize_egress(id,authorize_egress)
      sg = @resource.security_group(id)
      sg.authorize_egress(authorize_egress)
    end

    def authorize_ingress(id,authorize_ingress)
      sg = @resource.security_group(id)
      sg.authorize_ingress(authorize_ingress)
    end

    def delete_security_group(security_group_id)
      @client.delete_security_group({
                                        group_id: security_group_id,
                                    })
    end

    def create_key_pairs(key_pair_name)
      @client.create_key_pair({
                                  key_name: key_pair_name
                              })
    end

    def create_instances(image_id,min_count,max_count,key_pair_name,security_group,encoded_script,instance_type,config)
      @resource.create_instances({
                                     image_id: image_id,
                                     min_count: min_count,
                                     max_count: max_count,
                                     key_name: key_pair_name,
                                     user_data: encoded_script,
                                     instance_type: instance_type,
                                     placement: {
                                         availability_zone: config.az
                                     },
                                     network_interfaces: [
                                         {
                                             device_index: 0,
                                             subnet_id: config.subnet_id,
                                             associate_public_ip_address: true,
                                             groups: [security_group.security_group_id],
                                         },
                                     ],
                                 })
    end

    def delete_key_pairs(key_pair_name)
      @client.delete_key_pair({
                                  key_name: key_pair_name
                              })
    end

    def wait_for_instance_status_ok(instance_id)
      @resource.client.wait_until(:instance_status_ok, {instance_ids: [instance_id]}) unless stub?
    end

    def wait_for_instance_terminated(instance_id)
      @resource.client.wait_until(:instance_terminated, {instance_ids: [instance_id]}) unless stub?
    end

    def wait_for_instance_running(instance_id)
      @resource.client.wait_until(:instance_running, {instance_ids: [instance_id]})  unless stub?
    end

    def wait_for_instance_stopped(instance_id)
      @resource.client.wait_until(:instance_stopped, {instance_ids: [instance_id]}) unless stub?
    end

  end

  class Ec2ApiGatewayStub < Ec2ApiGateway
    def initialize
      @client = Aws::EC2::Client.new(stub_responses: true)
      @resource = Aws::EC2::Resource.new(stub_responses: true,client: client)
      @stub = true
    end
  end
end
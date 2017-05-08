module EC2
  class Ec2Instance
    def initialize(ec2)
      @config = ec2.config
      @gateway = ec2.gateway
      script = ''
      @encoded_script = Base64.encode64(script)
      @image_id = @config.yaml['DEV']['EC2']['IMAGE_ID']
      @instance_type = @config.yaml['DEV']['EC2']['INSTANCE_TYPE']
      @min_count = @config.yaml['DEV']['EC2']['MIN_COUNT'].to_i
      @max_count = @config.yaml['DEV']['EC2']['MAX_COUNT'].to_i
      name_value = @config.yaml['DEV']['EC2']['INSTANCE_TAGS']['NAME_VALUE']
      group_value = @config.yaml['DEV']['EC2']['INSTANCE_TAGS']['GROUP_VALUE']
      @instance_tags = [{key: 'Name', value: name_value}, {key: 'Group', value: group_value}]
    end

    def create(security_group,key_pair)
      instance = @gateway.resource.create_instances({
                                                  image_id: @image_id,
                                                  min_count: @min_count,
                                                  max_count: @max_count,
                                                  key_name: key_pair.key_pair_name,
                                                  user_data: @encoded_script,
                                                  instance_type: @instance_type,
                                                  placement: {
                                                      availability_zone: @config.az
                                                  },
                                                  network_interfaces: [
                                                      {
                                                          device_index: 0,
                                                          subnet_id: @config.subnet_id,
                                                          associate_public_ip_address: true,
                                                          groups: [security_group.security_group_id],
                                                      },
                                                  ],
                                              })

      @config.ec2.client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]}) unless instance.empty?

      instance.create_tags({tags: @instance_tags})

      instance
    end

    def terminate
      instance_ids = get_instance_collection
      instance_ids.each do |instance_id|
        i = @gateway.resource.instance(instance_id)

        if i.exists?
          case i.state.code
            when 48 # terminated
              puts "#{instance_id} is already terminated"
            else
              i.terminate
          end
        end
        instance_ids
        @config.ec2.client.wait_until(:instance_terminated, {instance_ids: [instance_id]}) unless @config.stub?
        instance_ids = get_instance_collection
      end
    end

    def get_instance_collection
      instance_ids = []
      resp = @gateway.client.describe_instances(filters: [{name: "tag:Name", values: [@instance_tags[0][:value]]}])
      resp.reservations.each do |reservation|
        reservation.instances.each do |instance|
          instance_ids << instance.instance_id
        end
      end
      instance_ids
    end
  end
end
module EC2
  class Ec2Instance
    attr_reader :instance_id

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
      instance = @gateway.create_instances(@image_id,
                                  @min_count,
                                  @max_count,
                                  key_pair.key_pair_name,
                                  security_group,
                                  @encoded_script,
                                  @instance_type,
                                  @config)

      instance.empty? ? @instance_id = nil : @instance_id = instance.id
      @gateway.wait_for_instance_status_ok(instance)
      instance.create_tags({tags: @instance_tags})
      instance
    end

    def terminate
      values = [@instance_tags[0][:value]]
      instance_ids = @gateway.get_instance_collection(values)
      instance_ids.each do |instance_id|
        i = @gateway.find_instance_by_id(instance_id)

        if i.exists?
          case i.state.code
            when 48 # terminated
              puts "#{instance_id} is already terminated"
            else
              i.terminate
          end
        end
        instance_ids
        @gateway.wait_for_instance_terminated(instance_id)
        instance_ids = @gateway.get_instance_collection(values)
      end
    end

    def start
      values = [@instance_tags[0][:value]]
      instance_ids = @gateway.get_instance_collection(values)
      instance_ids.each do |instance_id|
        i = @gateway.find_instance_by_id(instance_id)

        if i.exists?
          case i.state.code
            when 0  # pending
              puts "#{instance_id} is pending, so it will be running in a bit"
            when 16  # started
              puts "#{instance_id} is already started"
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot start it"
            else
              puts "#{instance_id} is starting"
              i.start
              @gateway.wait_for_instance_running(instance_id)
          end
        end
      end
    end

    def stop
      values = [@instance_tags[0][:value]]
      instance_ids = @gateway.get_instance_collection(values)
      instance_ids.each do |instance_id|
        i = @gateway.find_instance_by_id(instance_id)

        if i.exists?
          case i.state.code
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot stop it"
            when 64  # stopping
              puts "#{instance_id} is stopping, so it will be stopped in a bit"
            when 89  # stopped
              puts "#{instance_id} is already stopped"
            else
              puts "#{instance_id} is stopping"
              i.stop
              @gateway.wait_for_instance_stopped(instance_id)
          end
        end
      end
    end

    def reboot
      values = [@instance_tags[0][:value]]
      instance_ids = @gateway.get_instance_collection(values)
      instance_ids.each do |instance_id|
        i = @gateway.find_instance_by_id(instance_id)

        if i.exists?
          case i.state.code
            when 48  # terminated
              puts "#{instance_id} is terminated, so you cannot reboot it"
            else
              puts "#{instance_id} is rebooting"
              i.reboot
              @gateway.wait_for_instance_status_ok(instance_id)
          end
        end
      end
    end
  end
end
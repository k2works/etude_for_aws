module Ec2SpecHelper
  def create_ec2_instance(vpc)
    if SERVICE_STUB
      EC2::Ec2Stub.new(vpc).create
    else
      EC2::Ec2.new(vpc).create
    end
  end

  def destroy_ec2_instance(vpc)
    if SERVICE_STUB
      EC2::Ec2Stub.new(vpc).destroy
    else
      EC2::Ec2.new(vpc).destroy
    end
  end

  def start_ec2_instance(vpc)
    if SERVICE_STUB
      EC2::Ec2Stub.new(vpc).start
    else
      EC2::Ec2.new(vpc).start
    end
  end

  def stop_ec2_instance(vpc)
    if SERVICE_STUB
      EC2::Ec2Stub.new(vpc).stop
    else
      EC2::Ec2.new(vpc).stop
    end
  end

  def reboot_ec2_instance(vpc)
    if SERVICE_STUB
      EC2::Ec2Stub.new(vpc).reboot
    else
      EC2::Ec2.new(vpc).reboot
    end
  end
end

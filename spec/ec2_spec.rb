require 'spec_helper'
include CfmVpcSpecHelper
include Ec2SpecHelper

RSpec.describe EC2::Ec2 do
  SERVICE_STUB = true

  context 'Using Vpc' do
    context 'Simple Vpc' do
      let(:vpc_builder) {VPC::VpcDirector.new(VPC::SimpleVpcStub.new)}
      let(:ec2) { EC2::Ec2Stub.new(vpc_builder.builder) }

      describe '#create' do
        before(:each) do
          vpc_builder.create
        end

        after(:each) do
          vpc_builder.destroy
        end
        it 'crate instance with security group and keypair' do
          ec2.create
          expect(ec2.ec2_instances).not_to be_nil
          expect(ec2.security_group.security_group_id).not_to be_nil
          expect(ec2.key_pair).not_to be_nil
        end
      end

      describe '#start' do
        it 'start instance' do
          ec2.start
        end
      end

      describe '#reboot' do
        it 'reboot instance' do
          ec2.reboot
        end
      end

      describe '#stop' do
        it 'stop instance' do
          ec2.stop
        end
      end

      describe '#destroy' do
        before(:each) do
          vpc_builder.create
          ec2.create
        end

        it 'delete instance with security group and keypair' do
          ec2.destroy
          expect(ec2.ec2_instances).to be_empty
          expect(ec2.security_group).to be_nil
          expect(ec2.key_pair).to be_nil
        end
      end
    end
  end

  context 'Using Vpc From CloudFormation' do
    context 'One Availability Zones One PublicSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(1),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(1),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(1),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#stop' do
        it 'stop instances' do
          stop_ec2_instance(vpc)
        end
      end

      describe '#start' do
        it 'start instances' do
          start_ec2_instance(vpc)
        end
      end

      describe '#reboot' do
        it 'reboot instances' do
          reboot_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end

    context 'One Availability Zones Two PublicSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(2),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(2),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(2),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end

    context 'One Availability Zones One PublicSubnet One PrivateSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(3),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(3),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(3),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end

    context 'Two Availability Zones Two PrivateSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(4),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(4),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(4),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end

    context 'Two Availability Zones Two PublicSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(5),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(5),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(5),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end

    context 'Two Availability Zones One PublicSubnet and PrivateSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(6),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(6),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(6),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end

    context 'Two Availability Zones Two PublicSubnet and PrivateSubnet Virtual private cloud' do
      before(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(7),SERVICE_STUB).create
      end

      after(:all) do
        setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(7),SERVICE_STUB).destroy
      end

      let(:vpc) { setup_create_vpc_instance(CFM::Vpc::TYPE.fetch(7),SERVICE_STUB) }
      describe '#create' do
        it 'crate instance with security group and keypair' do
          create_ec2_instance(vpc)
        end
      end

      describe '#destroy' do
        it 'delete instance with security group and keypair' do
          destroy_ec2_instance(vpc)
        end
      end
    end
  end
end


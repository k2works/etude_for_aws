# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "hiroshima-arc/gin_and_bitters"
  config.vm.box_version = "0.3.0"

  config.vm.network :forwarded_port, guest:8080, host:9000, id:"jenkins"
  config.vm.network :private_network, ip:"127.0.0.1"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end

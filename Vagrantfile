# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos6.5"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"

  config.vm.define :sender do |sender|
    sender.vm.hostname = "sender"
    sender.vm.network :private_network, ip: "192.168.33.10", virtualbox__intnet: "intnet"
    sender.vm.provision :shell, path: "sender/provision.sh"
  end

  config.vm.define :receiver do |receiver|
    receiver.vm.hostname = "receiver"
    receiver.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    receiver.vm.network :private_network, ip: "192.168.33.20", virtualbox__intnet: "intnet"
    receiver.vm.network :forwarded_port, guest: 80, host: 10080
    receiver.vm.provision :shell, path: "receiver/provision.sh"
  end
end

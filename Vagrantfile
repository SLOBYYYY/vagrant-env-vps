# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "base"

  config.vm.network :private_network, ip: "1.1.1.3"

  config.vm.synced_folder ".", "/home/vagrant/vps"

  config.vm.provision :shell, :path => "install.sh"

  # For resolv.conf to resolve hosts while sending emails
  config.vm.provider "virtualbox" do |v|
  	v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "base"

  config.vm.network "private_network", ip: "192.168.10.13"

  config.vm.synced_folder ".", "/home/vagrant/vps"

  config.vm.provision :shell, :path => "provision/install.sh", :args => "/home/vagrant/vps farmmixerp"
end

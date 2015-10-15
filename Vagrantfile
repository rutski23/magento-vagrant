# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
  
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  
  config.vm.provider "virtualbox" do |vb|
     vb.name = "Magento Dev"
     vb.memory = 4096
	 vb.cpus = 2
  end

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./magento", "/var/www/html/magento/"
  
  config.vm.provision "shell", path: "bootstrap.sh"
end

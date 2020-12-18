# -*- mode: ruby -*-
# vi: set ft=ruby :

NODE_NUM = 2
SETUP_SCRIPT = "masterSetup.sh"

Vagrant.configure("2") do |config|

    # Kubernetes Master Server
    config.vm.define "master" do |master|
        master.vm.box = "hashicorp/bionic64"
        master.vm.box_version = "1.0.282"
        master.vm.network "private_network", ip: "10.0.0.200"
        master.vm.provider "virtualbox" do |v|
            v.name = "master"
            v.gui = true
            v.memory = 2048
            v.cpus = 2
        end
        # master.vm.provision :docker
        master.vm.provision :shell, path: SETUP_SCRIPT
    end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if ENV['REDHAT'] == '1'
    config.vm.box     = 'centos-6-x86_64'
    config.vm.box_url = 'http://dl.dropbox.com/u/1627760/centos-6.0-x86_64.box'
  elsif ENV['LUCID'] == '1'
    config.vm.box     = "lucid64"
    config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
  else
    config.vm.box     = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.network "forwarded_port", guest:  80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 8443

  # cabbage
  config.vm.define "cabbage" do |cabbage|

    cabbage.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = ["modules", "local-modules"]
      puppet.manifest_file  = "cabbage.pp"
    end

  end
  
  # cucumber
  config.vm.define "cucumber" do |cucumber|

    cucumber.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = ["modules", "local-modules"]
      puppet.manifest_file  = "cucumber.pp"
    end

  end

  # eggplant
  config.vm.define "eggplant" do |eggplant|

    eggplant.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = ["modules", "local-modules"]
      puppet.manifest_file  = "eggplant.pp"
    end

  end

  # kale
  config.vm.define "kale" do |kale|

    kale.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = ["modules", "local-modules"]
      puppet.manifest_file  = "kale.pp"
    end

  end

  # lettuce
  config.vm.define "lettuce" do |lettuce|

    lettuce.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = ["modules", "local-modules"]
      puppet.manifest_file  = "lettuce.pp"
    end

  end

  # spinach
  config.vm.define "spinach" do |spinach|

    spinach.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = ["modules", "local-modules"]
      puppet.manifest_file  = "spinach.pp"
    end

  end

end

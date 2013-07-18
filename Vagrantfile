# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "raring-amd64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.hostname = 'fedserv'

  # mediagoblin
  config.vm.network :forwarded_port, guest: 6543, host: 6543

  #config.vm.network :public_network
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    ## Don't boot with headless mode
    #vb.gui = true

    # set the name
    #vb.name = 'fedserv'

    ### Use VBoxManage to customize the VM. For example to change memory:
    ##vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.module_path    = "puppet/modules"
    puppet.manifests_path = "puppet"
    puppet.manifest_file  = "init.pp"
  end
end

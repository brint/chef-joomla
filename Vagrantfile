# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "cookbook-joomla"
  config.vm.box = "vagrant-ubuntu-12.04"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "33.33.33.10"
  config.omnibus.chef_version = "11.6.0"
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.json = {
      :mysql => {
        :server_root_password => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password => 'replpass'
      },
      :joomla => {
        :db => {
          :pass => "joomT3st"
        }
      }
    }
    chef.run_list = [
      "recipe[apt]",
      "recipe[joomla::mysql]",
      "recipe[joomla::default]",
    ]
  end
end

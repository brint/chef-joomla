chef-joomla
===========

[![Build Status](https://api.travis-ci.org/brint/chef-joomla.svg?branch=master)](https://travis-ci.org/brint/chef-joomla)
[![Dependency Status](https://gemnasium.com/brint/chef-joomla.png)](https://gemnasium.com/brint/chef-joomla)

Still tinkering.  Doing dev with rackspace-vagrant.

Cookbook to install [Joomla](http://www.joomla.org/) with
[Nginx](http://nginx.org/) and
[PHP-FPM](http://php.net/manual/en/install.fpm.php).  This cookbook aims to
leverage as many [opscode community
cookbooks](http://community.opscode.com/cookbooks) as possible.

Getting your Environment Up
===========================
* `git clone` the repo
* Run `bundle install` within the repo
* Install [vagrant](http://www.vagrantup.com/downloads.html) from the vagrant
website, avoid using gem to perform the installation since it will install a
very old version.
* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install vagrant plugins for
[vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) and
[vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf)  
`vagrant plugin install vagrant-omnibus`  
`vagrant plugin install vagrant-berkshelf`  
* Once all plugins are installed, run the cookbook with `vagrant up`

For more information on how to leverage Vagrant, check out their
[documentation](http://docs.vagrantup.com/v2/getting-started/index.html).

TODO
====
Still tinkering with this cookbook, adding features and functionality as time
permits.  This cookbook is not yet production ready.

* Need to fix memcache sessions setup
* Add admin user via cookbook
* Flush out documentation
* Setup build tests

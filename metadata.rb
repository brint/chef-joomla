# coding: utf-8
name             'joomla'
maintainer       "Brint O'Hearn"
maintainer_email 'brint.ohearn@rackspace.com'
license          'Apache 2.0'
description      'Joomla'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.0'
recipe           'joomla::default', 'Installs Joomla'
recipe           'joomla::mysql', 'Performs MySQL installation and
                                   configuration'

%w{ debian ubuntu centos redhat fedora amazon }.each do |os|
  supports os
end

%w{ apt yum nginx mysql database openssl php firewall iptables-ng
    mysql-chef_gem memcached varnish zip }.each do |cb|
  depends cb
end

depends 'mysql', '~> 5.3.6'
depends 'php-fpm', '~> 0.6.0'

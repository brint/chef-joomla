name             "joomla"
maintainer       "Brint O'Hearn"
maintainer_email "brint.ohearn@rackspace.com"
license          "Apache 2.0"
description      "Joomla"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.0"
recipe           "joomla::default", "Installs Joomla"
recipe           "joomla::mysql", "Performs MySQL installation and configuration"

%w{ debian ubuntu centos redhat fedora amazon }.each do |os|
  supports os
end

%w{ apt yum nginx mysql database openssl php firewall memcached varnish zip }.each do |cb|
  depends cb
end

depends "php-fpm", ">= 0.5.0"

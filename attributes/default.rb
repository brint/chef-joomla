# coding: utf-8
#
# Cookbook Name:: joomla
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://joomla.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Joomla Configuration
default['joomla']['user'] = 'joomla'
default['joomla']['group'] = 'joomla'
default['joomla']['domain'] = 'example.com'
default['joomla']['download_url'] = 'http://joomlacode.org/gf/download/frsrele\
                                     ase/18622/83487/Joomla_3.1.5-Stable-Full_\
                                     Package.zip'
default['joomla']['dir'] = File.join('/var/www/', node['joomla']['domain'])
default['joomla']['config_file'] = 'configuration.php'
default['joomla']['domain_aliases'] = ['www.example.com']
default['joomla']['system_packages'] = %w[ php5-mysql ]

default['joomla']['web_port'] = 80

default['joomla']['use_gzip'] = true # nginx gzip compression
default['joomla']['use_varnish'] = true # web cache
# TODO: Finish memcache support
default['joomla']['session_handler'] = 'database' # database or memcache

# Memcached configuration
# Memcache does not yet support multiple memcached servers
# Setting up as an array in anticipation of future capability
# Array IP:Port
default['joomla']['memcache']['servers'] = ['127.0.0.1:11211']

# Database Configuration
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['joomla']['db']['host'] = 'localhost'
default['joomla']['db']['user'] = 'joomla'
set_unless['joomla']['db']['pass'] = secure_password
default['joomla']['db']['database'] = 'joomla'
default['joomla']['db']['network_acl'] = ['localhost']

# Nginx Configuration
default['nginx']['default_site_enabled'] = false

# PHP-FPM Configuration
default['php-fpm']['pools'] = ['joomla']

default['php-fpm']['pool']['joomla']['listen'] = '/var/run/php-fpm-joomla.sock'
default['php-fpm']['pool']['joomla']['allowed_clients'] = ['127.0.0.1']
default['php-fpm']['pool']['joomla']['user'] = node['joomla']['user']
default['php-fpm']['pool']['joomla']['group'] = node['joomla']['group']
default['php-fpm']['pool']['joomla']['process_manager'] = 'dynamic'
default['php-fpm']['pool']['joomla']['max_children'] = 50
default['php-fpm']['pool']['joomla']['start_servers'] = 5
default['php-fpm']['pool']['joomla']['min_spare_servers'] = 5
default['php-fpm']['pool']['joomla']['max_spare_servers'] = 35
default['php-fpm']['pool']['joomla']['max_requests'] = 500
default['php-fpm']['pool']['joomla']['catch_workers_output'] = 'no'

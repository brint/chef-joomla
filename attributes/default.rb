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
default['joomla']['download_url'] = "http://joomlacode.org/gf/download/frsrelease/18622/83487/Joomla_3.1.5-Stable-Full_Package.zip"
default['joomla']['dir'] = "/var/www/joomla"
default['joomla']['domain'] = "example.com"
default['joomla']['system_packages'] = %w[ php5-mysql ]

# Database Configuration
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['joomla']['db']['host'] = "localhost"
default['joomla']['db']['user'] = "joomla"
set_unless['joomla']['db']['pass'] = secure_password
default['joomla']['db']['database'] = "joomla"
default['joomla']['db']['network_acl'] = [ "localhost" ]


# Nginx Configuration
default['nginx']['default_site_enabled'] = false


# PHP-FPM Configuration
default['php-fpm']['pools'] = ["joomla"]

default['php-fpm']['pool']['joomla']['listen'] = "/var/run/php-fpm-joomla.sock"
default['php-fpm']['pool']['joomla']['allowed_clients'] = ["127.0.0.1"]
default['php-fpm']['pool']['joomla']['user'] = "joomla"
default['php-fpm']['pool']['joomla']['group'] = "joomla"
default['php-fpm']['pool']['joomla']['process_manager'] = "dynamic"
default['php-fpm']['pool']['joomla']['max_children'] = 50
default['php-fpm']['pool']['joomla']['start_servers'] = 5
default['php-fpm']['pool']['joomla']['min_spare_servers'] = 5
default['php-fpm']['pool']['joomla']['max_spare_servers'] = 35
default['php-fpm']['pool']['joomla']['max_requests'] = 500
default['php-fpm']['pool']['joomla']['catch_workers_output'] = "no"

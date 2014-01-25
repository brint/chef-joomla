#
# Cookbook Name:: joomla
# Recipe:: memcache
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install and configure memcache client settings
# This will not install memcached.

package "php5-memcache" do
  action :install
  notifies :restart, "service[php-fpm]", :delayed
end

bash "Configure Joomla to use Memcache for Sessions" do
  cwd node['joomla']['dir']
  code <<-EOH
  sed -i 's/public \$session_handler = .*/public $session_handler = \'#{node['joomla']['session_handler']}\';/g' #{node['joomla']['config_file']}
  EOH
end

## TODO: Add handling for setting memcached servers
# http://stackoverflow.com/questions/1260258/how-to-use-memcached-with-joomla

node['joomla']['memcache']['servers'].each do |srv|
  server, port = srv.split(':')
  include_recipe "joomla::memcached" if server == "localhost" || server == "127.0.0.1"
end

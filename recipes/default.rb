#
# Cookbook Name:: joomla
# Recipe:: default
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

include_recipe "mysql::ruby"
include_recipe "zip::default"

# Install system packages
node['joomla']['system_packages'].each do |pkg|
  package pkg
end

### PHP-FPM Configuration
# Add Joomla user
user node['php-fpm']['pool']['joomla']['user'] do
  comment "Joomla User"
  home node['joomla']['dir']
  system true
end

# Install PHP-FPM
include_recipe "php-fpm::default"

# Joomla install section

directory node['joomla']['dir'] do
  owner node['php-fpm']['pool']['joomla']['user']
  group node['php-fpm']['pool']['joomla']['group']
  mode "0755"
  action :create
  recursive true
end

unless node['joomla']['download_url'].empty?
  remote_file "#{Chef::Config[:file_cache_path]}/joomla.zip" do
    source node['joomla']['download_url']
    mode "0644"
    not_if { ::File.exists?(File.join(node['joomla']['dir'], "index.php")) }
  end
  execute "Unzip Joomla" do
    cwd node['joomla']['dir']
    command "unzip #{Chef::Config[:file_cache_path]}/joomla.zip"
    not_if { ::File.exists?(File.join(node['joomla']['dir'], "index.php")) }
  end
end

bash "Ensure correct permissions & ownership" do
  cwd node['joomla']['dir']
  code <<-EOH
  chown -R #{node['php-fpm']['pool']['joomla']['user']}:#{node['php-fpm']['pool']['joomla']['group']} #{node['joomla']['dir']}
  EOH
end

# Nginx Configuration
node.set['joomla']['web_port'] = 8080 if node['joomla']['use_varnish']

include_recipe "nginx::default"

template "#{node['nginx']['dir']}/sites-available/#{node['joomla']['domain']}.conf" do
  source "nginx-site.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[nginx]", :delayed
end

nginx_site "#{node['joomla']['domain']}.conf" do
  notifies :reload, resources(:service => "nginx")
end


include_recipe "joomla::varnish" if node['joomla']['use_varnish']

include_recipe "joomla::memcache" if node['joomla']['session_handler'] == "memcache"

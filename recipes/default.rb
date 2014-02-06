# coding: utf-8
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

include_recipe 'mysql::ruby'
include_recipe 'zip::default'

# Install system packages
node['joomla']['system_packages'].each do |pkg|
  package pkg
end

### PHP-FPM Configuration
# Add Joomla user
user node['php-fpm']['pool']['joomla']['user'] do
  comment 'Joomla User'
  home node['joomla']['dir']
  shell '/bin/bash'
  system true
end

# Install PHP-FPM
include_recipe 'php-fpm::default'

# Joomla install section
directory node['joomla']['dir'] do
  owner node['php-fpm']['pool']['joomla']['user']
  group node['php-fpm']['pool']['joomla']['group']
  mode 0755
  action :create
  recursive true
end

unless node['joomla']['download_url'].empty?
  remote_file "#{Chef::Config[:file_cache_path]}/joomla.zip" do
    source node['joomla']['download_url']
    mode '0644'
    not_if { ::File.exists?(File.join(node['joomla']['dir'], 'index.php')) }
  end
  execute 'Unzip Joomla' do
    cwd node['joomla']['dir']
    command "unzip #{Chef::Config[:file_cache_path]}/joomla.zip"
    not_if { ::File.exists?(File.join(node['joomla']['dir'], 'index.php')) }
  end
end

# Configure Joomla
if node['joomla']['cli_configure'] &&
                  !File.exists?(File.join(node['joomla']['dir'], '.installed'))
  template File.join(node['joomla']['dir'], 'configuration.php') do
    source 'configuration.php.erb'
    owner node['php-fpm']['pool']['joomla']['user']
    group node['php-fpm']['pool']['joomla']['group']
    mode 0644
  end

  # Database Configuration stuff
  case node['joomla']['db']['type']
  when 'mysql'
    bash 'Correct SQL table prefixes before import' do
      cwd File.join(node['joomla']['dir'], 'installation', 'sql', 'mysql')
      code <<-EOH
      sed -i 's/#__/#{node['joomla']['jconfig']['dbprefix']}/g' joomla.sql
      EOH
    end

    connection_string = "-u#{node['joomla']['db']['user']} \
                         -p#{node['joomla']['db']['pass']} \
                         -h #{node['joomla']['db']['host']} \
                         #{node['joomla']['db']['database']}"

    bash 'Import base joomla.sql' do
      code <<-EOH
      mysql #{connection_string} < \
      #{File.join(node['joomla']['dir'], 'installation', 'sql', 'mysql',
                  'joomla.sql')}
      EOH
    end

    # Setup Admin User
    user_file = '/root/user.sql'
    template user_file do
      source 'user.sql.erb'
      owner 'root'
      group 'root'
      mode 0600
      variables(
        name: node['joomla']['admin_user']['name'],
        username: node['joomla']['admin_user']['username'],
        password: node['joomla']['admin_user']['password'],
        email: node['joomla']['admin_user']['email'],
        gid: 8
      )
    end

    bash 'Initialize admin user' do
      code <<-EOH
      mysql #{connection_string} < #{user_file}
      rm -f #{user_file}
      EOH
    end

  else
    log "Unable to setup database for #{node['joomla']['db']['type']}"
  end

  directory 'Remove Joomla Install directory' do
    path File.join(node['joomla']['dir'], 'installation')
    action :delete
    recursive true
  end

  bash 'Touch installed file' do
    cwd node['joomla']['dir']
    code 'touch .installed'
  end
end

bash 'Ensure correct permissions & ownership' do
  cwd node['joomla']['dir']
  code <<-EOH
  chown -R #{node['joomla']['user']}:#{node['joomla']['group']} \
  #{node['joomla']['dir']}
  EOH
end

# Nginx Configuration
node.set['joomla']['nginx_port'] = node['joomla']['web_port']
node.set['joomla']['nginx_port'] = 8080 if node['joomla']['use_varnish']

include_recipe 'nginx::default'

template File.join(node['nginx']['dir'], 'sites-available',
                   "#{node['joomla']['domain']}.conf") do
  source 'nginx-site.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]', :delayed
end

nginx_site "#{node['joomla']['domain']}.conf" do
  notifies :reload, 'service[nginx]'
end

include_recipe 'joomla::varnish' if node['joomla']['use_varnish']

if node['joomla']['session_handler'] == 'memcache'
  include_recipe 'joomla::memcache'
end

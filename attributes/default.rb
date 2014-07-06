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
default['joomla']['group'] = 'www-data'
default['joomla']['domain'] = 'example.com'
default['joomla']['download_url'] = 'http://joomlacode.org/gf/download/frsrel'\
                                    'ease/19143/157504/Joomla_3.2.2-Stable-Fu'\
                                    'll_Package.zip'
default['joomla']['dir'] = File.join('/var/www', node['joomla']['domain'])
default['joomla']['config_file'] = 'configuration.php'
default['joomla']['domain_aliases'] = ['www.example.com']
default['joomla']['system_packages'] = %w( php5-mysql php5-cli )

default['joomla']['web_port'] = 80

default['joomla']['use_gzip'] = '1' # nginx gzip compression
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

default['joomla']['db']['type'] = 'mysql'
default['joomla']['db']['host'] = 'localhost'
default['joomla']['db']['user'] = 'joomla'
set_unless['joomla']['db']['pass'] = secure_password
default['joomla']['db']['database'] = 'Joomla16'
default['joomla']['db']['network_acl'] = ['localhost']

# The following configuration will be used in configuring Joomla via CLI. This
# has been tested with Joomla 3.2.1.  This may not work with newer or older
# versions of Joomla.  To enable CLI configuration, set the 'cli_configure'
# attribute to true.
default['joomla']['cli_configure'] = false
default['joomla']['admin_user']['name'] = 'Admin User'
default['joomla']['admin_user']['username'] = 'admin'
set_unless['joomla']['admin_user']['password'] = secure_password
default['joomla']['admin_user']['email'] = 'admin@localhost'

default['joomla']['jconfig']['offline'] = '0'
default['joomla']['jconfig']['offline_message'] = 'This site is down for
                                                   maintenance.<br /> Please
                                                   check back again soon.'
default['joomla']['jconfig']['display_offline_message'] = '1'
default['joomla']['jconfig']['offline_image'] = ''
default['joomla']['jconfig']['sitename'] = 'Joomla!'
default['joomla']['jconfig']['editor'] = 'tinymce'
default['joomla']['jconfig']['captcha'] = '0'
default['joomla']['jconfig']['list_limit'] = '20'
default['joomla']['jconfig']['root_user'] = '42'
default['joomla']['jconfig']['access'] = '1'

default['joomla']['jconfig']['dbtype'] = node['joomla']['db']['type']
default['joomla']['jconfig']['host'] = node['joomla']['db']['host']
default['joomla']['jconfig']['user'] = node['joomla']['db']['user']
default['joomla']['jconfig']['password'] = node['joomla']['db']['pass']
default['joomla']['jconfig']['db'] = node['joomla']['db']['database']
default['joomla']['jconfig']['dbprefix'] = 'jos_'

set_unless['joomla']['jconfig']['secret'] = secure_password
default['joomla']['jconfig']['gzip'] = node['joomla']['use_gzip']
default['joomla']['jconfig']['error_reporting'] = 'default'
default['joomla']['jconfig']['helpurl'] = 'http://help.joomla.org/proxy/index'\
                                          '.php?option=com_help&amp;keyref=He'\
                                          'lp{major}{minor}:{keyref}'
default['joomla']['jconfig']['ftp_host'] = ''
default['joomla']['jconfig']['ftp_port'] = ''
default['joomla']['jconfig']['ftp_user'] = ''
default['joomla']['jconfig']['ftp_pass'] = ''
default['joomla']['jconfig']['ftp_root'] = ''
default['joomla']['jconfig']['ftp_enable'] =
default['joomla']['jconfig']['tmp_path'] = '/tmp'
default['joomla']['jconfig']['log_path'] = '/var/logs'
default['joomla']['jconfig']['live_site'] = ''
default['joomla']['jconfig']['force_ssl'] = 0

default['joomla']['jconfig']['offset'] = 'UTC'
default['joomla']['jconfig']['lifetime'] = '15'
default['joomla']['jconfig']['session_handler'] =
                                              node['joomla']['session_handler']
default['joomla']['jconfig']['mailer'] = 'mail'
default['joomla']['jconfig']['mailfrom'] = "joomla@#{node['joomla']['domain']}"
default['joomla']['jconfig']['fromname'] = 'Joomla'
default['joomla']['jconfig']['sendmail'] = '/usr/sbin/sendmail'
default['joomla']['jconfig']['smtpauth'] = '0'
default['joomla']['jconfig']['smtpuser'] = ''
default['joomla']['jconfig']['smtppass'] = ''
default['joomla']['jconfig']['smtphost'] = 'localhost'

default['joomla']['jconfig']['caching'] = '0'
default['joomla']['jconfig']['cachetime'] = '15'
default['joomla']['jconfig']['cache_handler'] = 'file'

default['joomla']['jconfig']['debug'] = '0'
default['joomla']['jconfig']['debug_lang'] = '0'
default['joomla']['jconfig']['MetaDesc'] =
            'Joomla! - the dynamic portal engine and content management system'
default['joomla']['jconfig']['MetaKeys'] = 'joomla, Joomla'
default['joomla']['jconfig']['MetaTitle'] = '1'
default['joomla']['jconfig']['MetaAuthor'] = '1'
default['joomla']['jconfig']['MetaVersion'] = '0'
default['joomla']['jconfig']['robots'] = ''

default['joomla']['jconfig']['sef'] = '1'
default['joomla']['jconfig']['sef_rewrite'] = '0'
default['joomla']['jconfig']['sef_suffix'] = '0'
default['joomla']['jconfig']['unicodeslugs'] = '0'

default['joomla']['jconfig']['feed_limit'] = 10
default['joomla']['jconfig']['feed_email'] = 'author'
# End CLI config options

# Nginx Configuration
default['nginx']['default_site_enabled'] = false

# PHP-FPM Configuration
default['php-fpm']['pools'] = [
  {
    name: 'joomla',
    user: node['joomla']['user'],
    group: node['joomla']['group'],
    listen_owner: node['joomla']['user'],
    listen_group: node['joomla']['group'],
    max_children: 50,
    process_manager: 'dynamic',
    start_servers: 5
  }
]

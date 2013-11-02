# Cookbook Name:: joomla
# Attributes:: mysql
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

default['mysql']['tunable']['thread_cache_size'] = 64
default['mysql']['tunable']['sort_buffer_size'] = '4M'
default['mysql']['tunable']['query_cache_limit'] = '2M'
default['mysql']['tunable']['join_buffer_size'] = '4M'

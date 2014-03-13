#
# Cookbook Name:: rackspace_redis
# Recipe:: default
#
# Copyright 2014, Rackspace, US Inc.
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

include_recipe 'rackspace_redis::install'

template node['rackspace_redis']['redis_server']['config_file'] do
  cookbook node['rackspace_redis']['templates_cookbook']['redis_server_config']
  owner 'root'
  group 'root'
  mode 0664
  source 'redis.conf.erb'
  variables(
    config: node['rackspace_redis']['redis_server']['config']
    )
  notifies :restart, "service[#{node['rackspace_redis']['redis_server']['servicename']}]"
end

service node['rackspace_redis']['redis_server']['servicename'] do
  case node['platform']
  when 'ubuntu', 'debian'
    supports status: true, restart: true, reload: true
  when 'redhat', 'centos'
    supports status: true, restart: true, reload: false
  end
  action [:enable, :start]
end

#
# Cookbook Name:: rackspace_redis
# Recipe:: sentinel
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

# init script for redis-sentinel non-existent on Ubuntu. Drop one off.
case node['platform']
when 'ubuntu', 'debian'
  template node['rackspace_redis']['redis_sentinel']['init_script'] do
    cookbook node['rackspace_redis']['templates_cookbook']['redis_sentinel_config']
    owner 'root'
    group 'root'
    mode 0664
    source 'upstart-redis-sentinel.erb'
    variables(
      configfile: node['rackspace_redis']['redis_sentinel']['config_file'],
      pidfile: node['rackspace_redis']['redis_sentinel']['config']['pidfile']
      )
    action :create
  end
end

template node['rackspace_redis']['redis_sentinel']['config_file'] do
  cookbook node['rackspace_redis']['templates_cookbook']['redis_sentinel_config']
  owner 'root'
  group 'root'
  mode 0664
  source 'redis-sentinel.conf.erb'
  variables(
    sentinelhosts: node['rackspace_redis']['redis_sentinel']['config']['hosts'],
    port: node['rackspace_redis']['redis_sentinel']['config']['port'],
    pidfile: node['rackspace_redis']['redis_sentinel']['config']['pidfile'],
    logfile: node['rackspace_redis']['redis_sentinel']['config']['logfile']
    )
  notifies :restart, "service[#{node['rackspace_redis']['redis_sentinel']['servicename']}]"
end

service node['rackspace_redis']['redis_sentinel']['servicename'] do
  case node['platform']
  when 'ubuntu', 'debian'
    supports status: true, restart: true, reload: false
  when 'redhat', 'centos'
    supports status: true, restart: true, reload: false
  end
  action [:enable, :start]
end

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

case node['platform']
when 'ubuntu', 'debian'

  rackspace_apt_repository 'ppa-redis' do
    uri 'http://ppa.launchpad.net/rwky/redis/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    deb_src :true
    keyserver 'keyserver.ubuntu.com'
    key '5862E31D'
  end
     
  include_recipe 'rackspace_apt'

#  package 'python-software-properties' do
#    action :install
#  end

  # Adding PPA for more up-to-date version of redis
#  execute 'setup-rwky/redis-ppa' do
#    command 'add-apt-repository -y ppa:rwky/redis'
#    ignore_failure false
#    notifies :run, 'execute[apt-get update]', :immediately
#  end

when 'redhat', 'centos'
  include_recipe 'rackspace_yum'

  # Make sure the epel repository exists
  rackspace_yum_repository 'epel' do
    description 'Extra Packages for Enterprise Linux'
    mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
    action :create
    not_if 'test -f /etc/yum.repos.d/epel.repo'
  end

  # Using Remi repository for a more up-to-date version of redis
  rackspace_yum_repository 'remi' do
    description 'Les RPM de remi pour Enterprise Linux $releasever - $basearch'
    mirrorlist 'http://rpms.famillecollet.com/enterprise/6/remi/mirror'
    gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
    includepkgs 'redis'
    action :create
  end
end

package node['rackspace_redis']['redis_server']['servicename'] do
  action :install
end

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

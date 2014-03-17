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

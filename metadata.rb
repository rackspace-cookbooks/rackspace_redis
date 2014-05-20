name			 'rackspace_redis'
maintainer       'Rackspace, US Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures redis'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

%w[ debian ubuntu centos redhat fedora scientific suse amazon].each do |os|
  supports os
end

recipe "rackspace_redis::default", "This recipe is used to install the prequisites for building and installing redis, as well as provides the LWRPs"
recipe "rackspace_redis::install", "This recipe is used to install redis"
recipe "rackspace_redis::configure", "This recipe is used to configure redis by creating the configuration files and init scripts"
recipe "rackspace_redis::sentinel", "This recipe is used to configure redis sentinels by creating the configuration files and init scripts"
recipe "rackspace_redis::enable", "This recipe is used to start the redis instances and enable them in the default run levels"
recipe "rackspace_redis::disable", "this recipe is used to stop the redis instances and disable them in the default run levels"
recipe "rackspace_redis::redis_gem", "this recipe will install the redis ruby gem into the system ruby"

depends "ulimit", ">= 0.1.2"
depends "build-essential", "=1.4.2"

name		 'rackspace_redis'
maintainer       'Rackspace, US Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures redis'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

%w{ redhat centos ubuntu debian }.each do |os|
  supports os
end

depends 'rackspace_apt', '~> 3.0'
depends 'rackspace_yum', '~> 4.0'

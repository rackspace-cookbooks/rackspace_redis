chef_gem 'redis'
require 'redis'

rackspace_redis_sentinel_set 'configure quorum' do
  master 'mymaster'
  option 'quorum'
  value  1
  port   26380
end

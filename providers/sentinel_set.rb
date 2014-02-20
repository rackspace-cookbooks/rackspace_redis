#
# Cookbook Name:: rackspace_redis
# Provider:: sentinel_set
#
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

def get_connection()
  sentinel = Redis.new(host: new_resource.host, port: new_resource.port)
  begin
    sentinel.ping
  rescue
    Chef::Log.warn "Unable to connect to redis sentinel host #{new_resource.host}:#{new_resource.port}; cannot configure sentinel."
    return nil
  end
  sentinel
end

def get_master_state(connection)
  begin
    state_array = connection.send("SENTINEL", "MASTER", new_resource.master)
  rescue Exception => e
    Chef::Log.warn "Cannot retrieve information for master '#{new_resource.master}': #{e}"
    return nil
  end
  Hash[*state_array]
end

action :set do
  sentinel = get_connection()
  exit 1 unless sentinel

  current_state = get_master_state(sentinel)
  exit 1 unless current_state

  unless current_state[new_resource.option] == new_resource.value
    sentinel.send("SENTINEL", "SET", new_resource.master, new_resource.option, new_resource.value)
    new_resource.updated_by_last_action(true)
  end
  sentinel.quit()
end

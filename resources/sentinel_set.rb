#
# Cookbook Name:: rackspace_redis
# Resource:: sentinel_set
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

actions :set
default_action :set

def initialize(*args)
  super
  @action = :set
end

attribute :master, kind_of: String, required: true
attribute :option, kind_of: String, required: true
attribute :value, kind_of: [String, Fixnum], required: true
# which sentinel are we connecting to? Ourself by default
attribute :host, kind_of: String, default: 'localhost'
attribute :port, kind_of: [String, Fixnum], default: 26379

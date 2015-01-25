# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

# Usage:
# be ruby bin/register_instance_with_elb.rb ap-southeast-1 hello-test i-xxx123

require 'aws-sdk'
require 'net/http'
#gem 'net-ssh', '~> 2.1.4'
require 'net/ssh'

instance = key_pair = group = nil

begin
  region = ARGV.shift
  elb_name = ARGV.shift
  instance_id = ARGV.shift

  elb = AWS::ELB.new(:region => region).load_balancers[elb_name]
  ec2 = AWS::EC2.new(:region => region).instances[instance_id]
  elb.availability_zones.enable(ec2.availability_zone)
  elb.instances.register(ec2)
end


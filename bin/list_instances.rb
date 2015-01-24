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

require 'aws-sdk'
require 'net/http'
#gem 'net-ssh', '~> 2.1.4'
require 'net/ssh'

instance = key_pair = group = nil

begin
  ec2 = AWS::EC2.new

  # optionally switch to a non-default region
  if region = ARGV.shift
    region = ec2.regions[region]
    unless region.exists?
      puts "Requested region '#{region.name}' does not exist.  Valid regions:"
      puts "  " + ec2.regions.map(&:name).join("\n  ")
      exit 1
    end

    # a region acts like the main EC2 interface
    ec2 = region
  end

  ec2.instances.each { |i| puts [i.id, i.status, i.tags.Name, i.dns_name].compact.join(', ') }
end


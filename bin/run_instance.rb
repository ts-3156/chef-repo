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

  prefix = 'ruby-sample-'
  if _p = ARGV.shift
    prefix = _p
  end
  time_now = Time.now.to_i

  # find the latest 32-bit EBS Amazon Linux AMI
  image = AWS.memoize do
    amazon_linux = ec2.images.with_owner("amazon").
      filter("root-device-type", "ebs").
      filter("architecture", "i386").
      filter("name", "amzn-ami*")

    # this only makes one request due to memoization
    amazon_linux.to_a.sort_by(&:name).last
  end
  puts "Using AMI: #{image.id}"

  # generate a key pair
  key_pair = ec2.key_pairs.create("#{prefix}#{time_now}")
  puts "Generated keypair #{key_pair.name}, fingerprint: #{key_pair.fingerprint}"
  puts key_pair.private_key

  # open SSH access
  group = ec2.security_groups.create("#{prefix}#{time_now}")
  group.authorize_ingress(:tcp, 22, "0.0.0.0/0")
  puts "Using security group: #{group.name}"

  # launch the instance
  instance = image.run_instance(:key_pair => key_pair,
                                :security_groups => group,
                                :instance_type => 't1.micro')
  instance.tags.Name = "#{prefix}#{time_now}"

  sleep 10 while instance.status == :pending
  instance.tap{ |i| puts "Launched instance #{[i.id, i.status, i.tags.Name, i.dns_name].compact.join(', ')}" }

  exit 1 unless instance.status == :running

  begin
    Net::SSH.start(instance.ip_address, "ec2-user",
                   :key_data => [key_pair.private_key]) do |ssh|
      puts "Running 'uname -a' on the instance yields:"
      puts ssh.exec!("uname -a")
    end
  rescue SystemCallError, Timeout::Error => e
    # port 22 might not be available immediately after the instance finishes launching
    sleep 1
    retry
  end

ensure
  # clean up
  #[instance,
  # group,
  # key_pair].compact.each(&:delete)
end


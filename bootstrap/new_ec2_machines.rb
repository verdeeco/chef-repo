#!/usr/bin/ruby

require 'rubygems'
require 'fog'

aws_key = "AKIAIQEHHS6762C4EA5A"
aws_key_secret = "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"
region = "us-east-1"
image_id = "ami-08f40561"
count = "1"
group_ids = ["default"]
key_name = "verdeeco_ec2_us_east"
availability_zone = "us-east-1d"
instance_type = "m1.large"

ec2 = Fog::AWS::Compute.new(
  :aws_access_key_id => aws_key,
  :aws_secret_access_key => aws_key_secret,
  :region => region)
  
ec2.run_instances(
    image_id,
    count,
    count,
    {
      "SecurityGroup" => group_ids,
      "KeyName" => key_name,
      "Placement.AvailabilityZone" => availability_zone,
      "InstanceType" => instance_type
    })
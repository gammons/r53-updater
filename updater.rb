#!/usr/bin/env ruby

require "rubygems"
require "aws-sdk"

HOSTED_ZONE_ID = "Z2SIN76Z7CT4WK".freeze
HOST = "local.grantammons.me".freeze

current_ip_address = `curl ifconfig.co`.strip
client = Aws::Route53::Client.new(region: "us-east-1")

args = {
  change_batch: {
    changes: [
      {
        action: "UPSERT",
        resource_record_set: {
          name: HOST,
          resource_records: [
            {
              value: current_ip_address
            }
          ],
          ttl: 180,
          type: "A"
        }
      }
    ],
    comment: "Update home ip address"
  },
  hosted_zone_id: HOSTED_ZONE_ID
}

resp = client.change_resource_record_sets(args)
puts resp.to_h

#!/usr/bin/env ruby
#
#

require 'net/http'
require 'open-uri'
require 'uri'

def get_iso_and_checksum(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  puts "iso_url: #{response['Location']}"
  puts "iso_sha256: #{open(url + '-sha256').read}"
end

get_iso_and_checksum('https://nixos.org/releases/nixos/latest-iso-minimal-i686-linux')
puts
get_iso_and_checksum('https://nixos.org/releases/nixos/latest-iso-minimal-x86_64-linux')

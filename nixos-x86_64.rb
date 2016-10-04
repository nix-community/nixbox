#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "x86_64",
  iso_url: "https://d3g5gsiof5omrk.cloudfront.net/nixos/16.09/nixos-16.09.680.4e14fd5/nixos-minimal-16.09.680.4e14fd5-x86_64-linux.iso",
  iso_sha256: "8700fd1861e83dba0c3c2cb348099d2499b2c52844d1771f1aacbf7458990bc8",
  virtualbox_guest_os: "Linux_64",
)

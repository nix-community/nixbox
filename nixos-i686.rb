#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "i686",
  iso_url: "https://d3g5gsiof5omrk.cloudfront.net/nixos/16.09/nixos-16.09.680.4e14fd5/nixos-minimal-16.09.680.4e14fd5-i686-linux.iso",
  iso_sha256: "01a1cd48f0876737a4b317f62fc030486139b03753490450ee919f0639586198",
  virtualbox_guest_os: "Linux",
)

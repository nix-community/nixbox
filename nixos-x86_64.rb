#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "x86_64",
  iso_url: "https://nixos.org/releases/nixos/14.12/nixos-14.12.496.5f7d374/nixos-minimal-14.12.496.5f7d374-x86_64-linux.iso",
  iso_sha256: "933aab9ddd3d02ea669313fb31a69e631d038926b1af03624e2602a9f78389bf",
  virtualbox_guest_os: "Linux_64",
)

#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "i686",
  iso_url: "https://nixos.org/releases/nixos/14.12/nixos-14.12.496.5f7d374/nixos-minimal-14.12.496.5f7d374-i686-linux.iso",
  iso_sha256: "637f5522570dc13ec8fee26ad1b0fb0eb3c1c85e19cd56032276367fb9ec1c69",
  virtualbox_guest_os: "Linux",
)

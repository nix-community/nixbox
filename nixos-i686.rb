#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "i686",
  iso_url: "https://nixos.org/releases/nixos/15.09/nixos-15.09.597.71e29b4/nixos-minimal-15.09.597.71e29b4-i686-linux.iso",
  iso_sha256: "659736e766149a49c6b8c3f24c47f168527e88f1aac0754bc5f4ae73ef7f0b0b",
  virtualbox_guest_os: "Linux",
)

#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "x86_64",
  iso_url: "https://nixos.org/releases/nixos/15.09/nixos-15.09.597.71e29b4/nixos-minimal-15.09.597.71e29b4-x86_64-linux.iso",
  iso_sha256: "c35133fb1e479ea9f42ffef9e4b06b6304914bbecb5337dfb75fe65fdf5298f5",
  virtualbox_guest_os: "Linux_64",
)

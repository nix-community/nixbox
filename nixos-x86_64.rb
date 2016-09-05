#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "x86_64",
  iso_url: "https://nixos.org/releases/nixos/16.03/nixos-16.03.1271.546618c/nixos-minimal-16.03.1271.546618c-x86_64-linux.iso",
  iso_sha256: "81c91427d7fd384097a8a811715f69379a81c3da02c7db39ec85f4a11f2d42f0",
  virtualbox_guest_os: "Linux_64",
)

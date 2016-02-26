#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "x86_64",
  iso_url: "https://nixos.org/releases/nixos/15.09/nixos-15.09.1076.9220f03/nixos-minimal-15.09.1076.9220f03-x86_64-linux.iso",
  iso_sha256: "77bd77859f937da23e9a45ccf50410ae32a41400e3b9ca3a8de212821b641c88",
  virtualbox_guest_os: "Linux_64",
)

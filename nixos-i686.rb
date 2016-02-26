#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "i686",
  iso_url: "https://nixos.org/releases/nixos/15.09/nixos-15.09.1076.9220f03/nixos-minimal-15.09.1076.9220f03-i686-linux.iso",
  iso_sha256: "4ffa1cbaa006bd6d804ecbf3da3c613fbf57602e9c383e5d985f2fbd6ff265f5",
  virtualbox_guest_os: "Linux",
)

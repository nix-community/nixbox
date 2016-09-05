#!/usr/bin/env ruby
require './gen_template.rb'

gen_template(
  arch: "i686",
  iso_url: "https://nixos.org/releases/nixos/16.03/nixos-16.03.1277.c84026f/nixos-minimal-16.03.1277.c84026f-i686-linux.iso",
  iso_sha256: "28e3b6bb814fbe26679cbf16bb538b86eab5a6c139670fba39254c4388643ac3",
  virtualbox_guest_os: "Linux",
)

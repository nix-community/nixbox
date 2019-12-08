#!/usr/bin/env nix-shell
#!nix-shell -i ruby
#
# Heuristic to update the ISO urls
#

require 'net/http'
require 'open-uri'
require 'uri'
require 'json'

isos = {}

ISO_RE = /"(https:\/\/[^"]+-([^-]+)-linux.iso)".*Minimal.*"(https:\/\/[^"]+.iso.sha256)"/i
open("https://nixos.org/nixos/download.html").each_line.grep(ISO_RE) do
  isos[$2] = {
    iso_url: $1,
    iso_sha256: open($3).read.strip.split.first,
  }
end

out = JSON.pretty_generate(isos)
puts out
File.write("iso_urls.json", out)

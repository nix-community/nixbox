#!/usr/bin/env nix-shell
#!nix-shell -i ruby
#
# Heuristic to update the ISO urls
#

require 'open-uri'
require 'json'
require 'rexml/document'
include REXML

isos = {}

xml = Document.new(open("https://nixos.org/nixos/download.html"))
xml.root.elements.each("body/*/*/*/*/*/ul/li") { |li|
  hrefs = li.get_elements("a").map { |a| a.attribute("href") }
  if hrefs.size == 2 and /.*minimal.*/i =~ hrefs[0].value
  then
    iso_url = hrefs[0].value
    arch_re = /https:\/\/.+-([^-]+)-linux.iso/
    arch = arch_re.match(iso_url).captures
    iso_sha256 = open(hrefs[1].value).read.strip.split.first
    if arch.size == 1
    then
      isos[arch[0]] = {
        iso_url: iso_url,
        iso_sha256: iso_sha256
      }
    end
  end
}

out = JSON.pretty_generate(isos)
puts out
File.write("iso_urls.json", out)

BUILDERS ?= "virtualbox-iso"

all: update build

update: update_iso update_template

# Fetches the latest iso urls
update_iso: iso_urls_update.rb
	./iso_urls_update.rb

update_template: nixos-i686.json nixos-x86_64.json

nixos-i686.json: gen_template.rb iso_urls.json
	./gen_template.rb i686 > $@

nixos-x86_64.json: gen_template.rb iso_urls.json
	./gen_template.rb x86_64 > $@

build: build-i686 build-x86_64

build-i686: nixos-i686.json
	packer build --only=${BUILDERS} $<

build-x86_64: nixos-x86_64.json
	packer build --only=${BUILDERS} $<

.PHONY: all update update_iso update_template build-i686 build-x86_64

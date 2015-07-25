
all: nixos-i686.json nixos-x86_64.json

nixos-i686.json: nixos-i686.rb gen_template.rb
	./$< > $@

nixos-x86_64.json: nixos-x86_64.rb gen_template.rb
	./$< > $@

.PHONY: all

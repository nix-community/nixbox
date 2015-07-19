
ISO_URL_32=http://releases.nixos.org/nixos/14.12/nixos-14.12.496.5f7d374/nixos-minimal-14.12.496.5f7d374-i686-linux.iso
ISO_SHA256_32=637f5522570dc13ec8fee26ad1b0fb0eb3c1c85e19cd56032276367fb9ec1c69
GUEST_OS_32=Linux

ISO_URL_64=https://nixos.org/releases/nixos/14.12/nixos-14.12.496.5f7d374/nixos-minimal-14.12.496.5f7d374-x86_64-linux.iso
ISO_SHA256_64=933aab9ddd3d02ea669313fb31a69e631d038926b1af03624e2602a9f78389bf
GUEST_OS_64=Linux_64

all: nixbox32-template.json nixbox64-template.json

nixbox32-virtualbox.box: nixbox32-template.json
	packer build $<

nixbox64-virtualbox.box: nixbox64-template.json
	packer build $<

nixbox32-template.json: nixbox-template.json.orig Makefile
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_32)|g' -e 's|ISO_SHA256|$(ISO_SHA256_32)|g' -e 's|GUEST_OS|$(GUEST_OS_32)|g' -e 's|NIXBOX|nixbox32|g' > $@

nixbox64-template.json: nixbox-template.json.orig Makefile
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_64)|g' -e 's|ISO_SHA256|$(ISO_SHA256_64)|g' -e 's|GUEST_OS|$(GUEST_OS_64)|g' -e 's|NIXBOX|nixbox64|g' > $@

.PHONY: all

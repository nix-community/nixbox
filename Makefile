
ISO_URL_32=http://nixos.org/releases/nixos/14.12/nixos-14.12.231.139ead2/nixos-minimal-14.12.231.139ead2-i686-linux.iso
ISO_MD5_32=0825f20b9f63b44d4f58dd4c205bdeeb
GUEST_OS_32=Linux

ISO_URL_64=http://nixos.org/releases/nixos/14.12/nixos-14.12.231.139ead2/nixos-minimal-14.12.231.139ead2-x86_64-linux.iso
ISO_MD5_64=d0f4cf841d0502dc96c68c13cb21a0e2
GUEST_OS_64=Linux_64

all: nixbox32-template.json nixbox64-template.json

nixbox32-virtualbox.box: nixbox32-template.json
	packer build $<

nixbox64-virtualbox.box: nixbox64-template.json
	packer build $<

nixbox32-template.json: nixbox-template.json.orig Makefile
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_32)|g' -e 's|ISO_MD5|$(ISO_MD5_32)|g' -e 's|GUEST_OS|$(GUEST_OS_32)|g' -e 's|NIXBOX|nixbox32|g' > $@

nixbox64-template.json: nixbox-template.json.orig Makefile
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_64)|g' -e 's|ISO_MD5|$(ISO_MD5_64)|g' -e 's|GUEST_OS|$(GUEST_OS_64)|g' -e 's|NIXBOX|nixbox64|g' > $@

.PHONY: all

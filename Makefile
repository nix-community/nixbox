
ISO_URL_32=http://releases.nixos.org/nixos/14.04/nixos-14.04.393.6593a98/nixos-minimal-14.04.393.6593a98-i686-linux.iso
ISO_MD5_32=dc14e90e601991a69ae23ff8bafdefb2
GUEST_OS_32=Linux

ISO_URL_64=http://releases.nixos.org/nixos/14.04/nixos-14.04.393.6593a98/nixos-minimal-14.04.393.6593a98-x86_64-linux.iso
ISO_MD5_64=13f5f51897ebf491c2b8db5274bafe1d
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

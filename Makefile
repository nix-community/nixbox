
ISO_URL_32=http://releases.nixos.org/nixos/13.10/nixos-13.10.35723.15586a1/nixos-minimal-13.10.35723.15586a1-i686-linux.iso
ISO_MD5_32=7b7996150b9d2b239d82f7526db29140
GUEST_OS_32=Linux

ISO_URL_64=http://releases.nixos.org/nixos/13.10/nixos-13.10.35723.15586a1/nixos-minimal-13.10.35723.15586a1-x86_64-linux.iso
ISO_MD5_64=73465988b04cdb611d26503bf968e2de
GUEST_OS_64=Linux_64

all: nixbox32-template.json nixbox64-template.json

nixbox32-template.json: nixbox-template.json.orig
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_32)|g' -e 's|ISO_MD5|$(ISO_MD5_32)|g' -e 's|GUEST_OS|$(GUEST_OS_32)|g' -e 's|NIXBOX|nixbox32|g' > $@

nixbox64-template.json: nixbox-template.json.orig
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_64)|g' -e 's|ISO_MD5|$(ISO_MD5_64)|g' -e 's|GUEST_OS|$(GUEST_OS_64)|g' -e 's|NIXBOX|nixbox64|g' > $@


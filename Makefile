
ISO_URL_32=http://nixos.org/releases/nixos/13.10/nixos-13.10.35455.45219b9/nixos-minimal-13.10.35455.45219b9-i686-linux.iso
ISO_MD5_32=c10f01734cb187e13068252e2cde565d
GUEST_OS_32=Linux

ISO_URL_64=http://nixos.org/releases/nixos/13.10/nixos-13.10.35455.45219b9/nixos-minimal-13.10.35455.45219b9-x86_64-linux.iso
ISO_MD5_64=fbac8c11661028e6f9c4ec293e1329e1
GUEST_OS_64=Linux_64

all: nixbox32-template.json nixbox64-template.json

nixbox32-template.json: nixbox-template.json.orig
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_32)|g' -e 's|ISO_MD5|$(ISO_MD5_32)|g' -e 's|GUEST_OS|$(GUEST_OS_32)|g' -e 's|NIXBOX|nixbox32|g' > $@

nixbox64-template.json: nixbox-template.json.orig
	cat $< | sed -e 's|ISO_URL|$(ISO_URL_64)|g' -e 's|ISO_MD5|$(ISO_MD5_64)|g' -e 's|GUEST_OS|$(GUEST_OS_64)|g' -e 's|NIXBOX|nixbox64|g' > $@


BUILDERS ?= "virtualbox-iso.virtualbox"
VERSION ?= 22.05
all: build

build: build-i686 build-x86_64

version:
	@echo "Build for ${ARCH} architecture and using the ${VERSION} NixOS iso version"

build-arch: version nixos.pkr.hcl
	@packer build \
	-var arch=${ARCH} \
	-var version=${VERSION} \
	-var iso_checksum="$(shell curl -sL https://channels.nixos.org/nixos-${VERSION}/latest-nixos-minimal-${ARCH}-linux.iso.sha256 | grep -Eo '^[0-9a-z]{64}')" \
	--only=${BUILDERS} \
	nixos.pkr.hcl

build-i686: 
	@${MAKE} build-arch ARCH=i686 VERSION=${VERSION}

build-x86_64:
	@${MAKE} build-arch ARCH=x86_64 VERSION=${VERSION}

.PHONY: all build-i686 build-x86_64

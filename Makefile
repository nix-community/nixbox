BUILDERS ?= "virtualbox-iso.virtualbox"

all: build

build: build-i686 build-x86_64

build-i686: nixos.pkr.hcl
	packer build -var-file="nixos.auto.pkvars.hcl" -var arch=i686 --only=${BUILDERS} $<

build-x86_64: nixos.pkr.hcl
	packer build -var-file="nixos.auto.pkvars.hcl" -var arch=x86_64 --only=${BUILDERS} $<

.PHONY: all build-i686 build-x86_64

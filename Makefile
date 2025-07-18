BUILDER ?= virtualbox-iso.virtualbox
VERSION ?= 23.05
ARCH ?= x86_64
REPO ?= nixbox/nixos
USE_EFI ?= false
REPO_NAME = $(word 1, $(subst /, ,${REPO}))
BOX_NAME = $(word 2, $(subst /, ,${REPO}))
BUILD_PROVIDER = $(word 1, $(subst -, ,$(word 2, $(subst ., ,${BUILDER}))))
ENVFILE ?=


ifdef ENVFILE
    include $(ENVFILE)
    export
endif


ifeq ($(USE_EFI),true)
    BUILDER=${BUILDER}-efi
endif

all: help

help: ## This help
	@find . -name Makefile -o -name "*.mk" | xargs -n1 grep -hE '^[a-z0-9\-]+:.* ##' | sed 's/\: .*##/:/g' | sort | column  -ts':'

version:
	@echo "Build for ${ARCH} architecture and using the ${VERSION} NixOS iso version"

build: nixos.pkr.hcl version ## [BUILDER] [ARCH] [VERSION] Build packer image
	packer init $<
	packer build \
	-var arch=${ARCH} \
	-var builder="${BUILDER}" \
	-var version=${VERSION} \
	-var iso_checksum="$(shell curl -sL https://channels.nixos.org/nixos-${VERSION}/latest-nixos-minimal-${ARCH}-linux.iso.sha256 | grep -Eo '^[0-9a-z]{64}')" \
	--only=${BUILDER} \
	--except=vagrant-registry \
	$<

build-all: ## [BUILDER] [VERSION] Build packer image
	@${MAKE} BUILDER=${BUILDER} VERSION=${VERSION} ARCH=x86_64 build
	@${MAKE} BUILDER=${BUILDER} VERSION=${VERSION} ARCH=i686 build

vagrant-plugin:
	@vagrant plugin list | grep vagrant-nixos-plugin || vagrant plugin install vagrant-nixos-plugin
	@vagrant plugin list | grep vagrant-disksize || vagrant plugin install vagrant-disksize

vagrant-add: vagrant-plugin ## Add vagrant box
	@test -f nixos-${VERSION}-${BUILDER}-${ARCH}.box && ARCH=${ARCH} vagrant box add --force nixbox-${ARCH} nixos-${VERSION}-${BUILDER}-${ARCH}.box	

vagrant-remove: vagrant-plugin ## Remove vagrant box
	@vagrant box remove nixbox-${ARCH}

vagrant-up: ## Try builded vagrant box
	@ARCH="${ARCH}" vagrant up --provider ${BUILD_PROVIDER}

vagrant-ssh: ## Connect to vagrant box
	@ARCH="${ARCH}" vagrant ssh

vagrant-destroy: ## Destroy vagrant box
	@ARCH="${ARCH}" vagrant destroy

packer-build:  nixos.pkr.hcl version ##Use packer push to vagrant-cloud
	packer init $<
	packer build \
	-var arch=${ARCH} \
	-var builder="${BUILDER}" \
	-var cloud_repo=${REPO} \
	-var version=${VERSION} \
	-var iso_checksum="$(shell curl -sL https://channels.nixos.org/nixos-${VERSION}/latest-nixos-minimal-${ARCH}-linux.iso.sha256 | grep -Eo '^[0-9a-z]{64}')" \
	--only=${BUILDER} \
	$<

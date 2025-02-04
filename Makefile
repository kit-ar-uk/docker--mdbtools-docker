# .ONESHELL:
.SHELLFLAGS = -e

TAG_VERSION=221213d

DH_ID_base=kitaruk/mdbtools-docker

# .ONESHELL:
# SHELL = bash
.SHELLFLAGS = -e

THIS_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TIMESTAMP=$(shell date -u +"%Y%m%d_%H%M%S%Z")

DOCKER_BIN=docker
#DOCKER_BIN=podman

BUILD_CACHE=
# # BUILD_CACHE=--pull
# # BUILD_CACHE=--no-cache --force-rm
# BUILD_CACHE=--pull --no-cache --force-rm

# BUILD_CMD = build
# BUILD_CMD = build --progress plain
# BUILD_CMD = buildx build --pull --push
# BUILD_CMD = buildx build --pull --push --platform linux/amd64
BUILD_CMD = buildx build --pull --push --platform linux/amd64,linux/arm64

all:
default:

.PHONY: buildx-deb
buildx-deb: r--buildx-deb

r--buildx-%:
	@echo "####################################################"
	# if needed, run this before
	#     docker buildx create --use
	$(DOCKER_BIN) $(BUILD_CMD) $(BUILD_CACHE) -f Dockerfile.$*-src \
			-t $(DH_ID_base):$* \
			-t $(DH_ID_base):$*-${TAG_VERSION} \
			. \
		| tee /tmp/docker--mdbtools-docker-$*.log \
		;\

# docker build --rm -f "Dockerfile" -t kitaruk/mdbtools-docker:ubuntu2004 "."
# docker buildx build --pull --push --rm -f "Dockerfile" -t kitaruk/mdbtools-docker:ubuntu2004 "."

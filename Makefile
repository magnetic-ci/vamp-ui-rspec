# See: http://clarkgrubb.com/makefile-style-guide
SHELL             := bash
.SHELLFLAGS       := -eu -o pipefail -c
.DEFAULT_GOAL     := default
.DELETE_ON_ERROR:
.SUFFIXES:

IMAGE := vamp-ui-rspec

# if Makefile.local exists, include it.
ifneq ("$(wildcard Makefile.local)", "")
	include Makefile.local
endif

ifeq ($(VAMP_GIT_BRANCH), $(filter $(VAMP_GIT_BRANCH), master ""))
	export VERSION := katana
else
	export VERSION := $(subst /,_,$(VAMP_GIT_BRANCH))
endif

# Targets
.PHONY: all
all: default

.PHONY: default
default: image test

.PHONY: image
image:
	docker build . -t $(IMAGE):$(VAMP_TAG_PREFIX)$(VERSION)

.PHONY: test
test: image
	docker run \
		--rm \
		-e DO_SCREENSHOTS=$(DO_SCREENSHOTS) \
		-e VAMP_URL=$(VAMP_URL) \
		-v $(CURDIR):/src \
		$(IMAGE):$(VERSION)

.PHONY: clean
clean:
	rm -rf $(CURDIR)/screen_*.png

.PHONY: dist-clean
dist-clean: clean
	-docker rmi $(IMAGE):$(VAMP_TAG_PREFIX)$(VERSION)

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

# Targets
.PHONY: all
all: default

.PHONY: default
default: image test

.PHONY: image
image:
	time docker build . -t $(IMAGE)

.PHONY: test
test: image
	time docker run \
		--rm \
		-e DO_SCREENSHOTS=$(DO_SCREENSHOTS) \
		-e VAMP_URL=$(VAMP_URL) \
		-v $(CURDIR):/src \
		$(IMAGE)

.PHONY: clean
clean:
	rm -rf $(CURDIR)/screen_*.png

.PHONY: dist-clean
dist-clean: clean
	docker rmi $(IMAGE)

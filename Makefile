SHELL := /bin/sh

APP_NAME := WebWatch
PACKAGE_NAME := webwatch
PACKAGE_VERSION := 1.5
PACKAGE_REVISION := 1
SOURCE_DIRECTORY := src
BUILD_DIRECTORY := build
PACKAGE_STAGE := $(BUILD_DIRECTORY)/package
PACKAGE_ARCH ?= $(shell getarch)
PACKAGE_FILE := $(CURDIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)-$(PACKAGE_REVISION)-$(PACKAGE_ARCH).hpkg
INSTALL_DIRECTORY ?= $(shell finddir B_USER_NONPACKAGED_DIRECTORY)/apps

.PHONY: all clean install hpkg

all:
	$(MAKE) -C $(SOURCE_DIRECTORY)

clean:
	$(MAKE) -C $(SOURCE_DIRECTORY) clean
	rm -rf $(PACKAGE_STAGE)

install: all
	@if [ -z "$(INSTALL_DIRECTORY)" ] || [ "$(INSTALL_DIRECTORY)" = "/apps" ]; then \
		echo "error: could not determine the user non-packaged applications directory" >&2; \
		exit 1; \
	fi; \
	binary=$$(find $(SOURCE_DIRECTORY) -maxdepth 2 -type f -name $(APP_NAME) -path '*/objects.*/*' -print -quit); \
	if [ -z "$$binary" ]; then \
		echo "error: could not find the built $(APP_NAME) binary" >&2; \
		exit 1; \
	fi; \
	mkdir -p "$(INSTALL_DIRECTORY)"; \
	install -m 755 "$$binary" "$(INSTALL_DIRECTORY)/$(APP_NAME)"; \
	echo "Installed $(APP_NAME) in $(INSTALL_DIRECTORY)"

hpkg: all
	@if [ -z "$(PACKAGE_ARCH)" ]; then \
		echo "error: could not determine the Haiku package architecture" >&2; \
		exit 1; \
	fi; \
	command -v package >/dev/null 2>&1 || { \
		echo "error: Haiku's package command was not found" >&2; \
		exit 1; \
	}; \
	binary=$$(find $(SOURCE_DIRECTORY) -maxdepth 2 -type f -name $(APP_NAME) -path '*/objects.*/*' -print -quit); \
	if [ -z "$$binary" ]; then \
		echo "error: could not find the built $(APP_NAME) binary" >&2; \
		exit 1; \
	fi; \
	rm -rf "$(PACKAGE_STAGE)"; \
	mkdir -p "$(PACKAGE_STAGE)/apps"; \
	install -m 755 "$$binary" "$(PACKAGE_STAGE)/apps/$(APP_NAME)"; \
	sed 's/@ARCH@/$(PACKAGE_ARCH)/g' packaging/PackageInfo.in > "$(PACKAGE_STAGE)/.PackageInfo"; \
	package create -C "$(PACKAGE_STAGE)" "$(PACKAGE_FILE)"; \
	echo "Created $(PACKAGE_FILE)"

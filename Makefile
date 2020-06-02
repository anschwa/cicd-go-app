# GNUmakefile
SHELL := bash
.ONESHELL:
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables

.PHONY: help
help: ## Display this help section
	@echo -e "Usage: make <command>\n\nAvailable commands are:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  %-38s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

########################################################################

PORT ?= 4242
BUILD_NUMBER ?= 0
TIMESTAMP ?= $(shell date +"%A %B %d, %Y, %r %Z")
BUILD_INFO ?= Build $(BUILD_NUMBER) from: $(TIMESTAMP)
LDFLAGS ?= '-X "main.Port=$(PORT)" -X "main.BuildInfo=$(BUILD_INFO)"'

########################################################################

.PHONY: build
build: ## Compiles this app for production
	go build -v -ldflags=$(LDFLAGS) -o cmd/app .

.PHONY: start
start: ## Runs the app
	go run -ldflags=$(LDFLAGS) -race .

.PHONY: test
test: fmt ## Generate mocks and run tests
	go test -ldflags=$(LDFLAGS) -race -cover ./...

.PHONY: cover
cover: ## Runs test for the given package name, and shows the coverage report
	go test -coverprofile coverage.out ./... && go tool cover -html coverage.out

.PHONY: fmt
fmt: deps gofmt govet ## Clean dependencies and run code linting / formatting

.PHONY: gofmt
gofmt:
	gofmt -l -w $(shell find . -type f -name "*.go" -not -path "./vendor/*")

.PHONY: govet
govet:
	go vet

.PHONY: deps
deps:
	go mod tidy

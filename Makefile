project_name = reshowcase

DUNE = opam exec -- dune

.DEFAULT_GOAL := help

.PHONY: help
help: ## Print this help message
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: create-switch
create-switch: ## Create opam switch
	opam switch create . 5.1.0~rc3 -y --deps-only

.PHONY: init
init: create-switch install ## Configure everything to develop this repository in local

.PHONY: install
install: ## Install development dependencies
	yarn install
	opam update
	opam install -y . --deps-only --with-test
	opam exec opam-check-npm-deps

.PHONY: build
build: ## Build the project
	$(DUNE) build

.PHONY: build_verbose
build_verbose: ## Build the project
	$(DUNE) build --verbose

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	$(DUNE) clean

.PHONY: format
format: ## Format the codebase with ocamlformat
	$(DUNE) build @fmt --auto-promote

.PHONY: format-check
format-check: ## Checks if format is correct
	$(DUNE) build @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	$(DUNE) build --watch

.PHONY: test
test: ## Run tests
	$(DUNE) build @runtest

.PHONY: start-example
start-example: ## Runs the example in watch mode
	$(DUNE) build -w @start-example

.PHONY: build-example
build-example: ## Builds the example
	$(DUNE) build @build-example


VIRTUAL_ENV=env
YQ_VERSION=3.1.0

## help | show this help command
help: Makefile
	@sed -n 's/^## //p' $< | column -ts '|'

include ../../dependencies.mk

## env | ensure that a virtual environment exists
$(VIRTUAL_ENV):
	python3 -m venv $@

## env/bin/yq | ensure that the yq command exists in the local virtual environment
$(VIRTUAL_ENV)/bin/yq: $(VIRTUAL_ENV)
	$(VIRTUAL_ENV)/bin/pip install yq==$(YQ_VERSION)

## install-overrides.yaml | build install-overrides.yaml for the current machine architecture
install-overrides.yaml: SHELL=/bin/bash
install-overrides.yaml: kustomize $(VIRTUAL_ENV)/bin/yq
	case $$(uname -m) in \
		arm64) \
			$< build $$(uname -m) | $(VIRTUAL_ENV)/bin/yq -y 'del(.metadata)' > $@ ; \
			;; \
		x86_64) \
			$< build $$(uname -m) | $(VIRTUAL_ENV)/bin/yq -y 'del(.metadata)' > $@ ; \
			;; \
		*) \
			echo "Unsupported architecture for istio manifests: $$(uname -m)" ; \
			exit 1 ; \
			;; \
	esac

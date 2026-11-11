SHELL := /bin/bash
.DEFAULT_GOAL := help
PYTHON ?= .venv/bin/python
KYVERNO ?= kyverno
TRIVY ?= trivy
KUBECTL ?= kubectl
CONTEXT ?=

.PHONY: help setup lint test scan plan
help:
	@echo 'setup: install YAML validator; lint: parse YAML; test: real Kyverno fixtures'
	@echo 'scan: Trivy HIGH/CRITICAL gate; plan: staging server dry-run with CONTEXT'
setup:
	python3 -m venv .venv
	.venv/bin/python -m pip install -r requirements-dev.txt
lint:
	$(PYTHON) scripts/check_manifests.py
test: lint
	$(KYVERNO) test kyverno/tests --detailed-results
scan:
	$(TRIVY) config --severity HIGH,CRITICAL --exit-code 1 kyverno
	$(TRIVY) config --severity HIGH,CRITICAL --exit-code 1 network-policies
plan:
	@test -n "$(CONTEXT)" || { echo 'Set CONTEXT to the intended staging context'; exit 2; }
	$(KUBECTL) --context "$(CONTEXT)" apply --dry-run=server -f kyverno/policies
	$(KUBECTL) --context "$(CONTEXT)" apply --dry-run=server -f network-policies

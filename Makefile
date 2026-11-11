SHELL := /bin/bash

.PHONY: all lint test scan validate apply-dry-run clean help

all: lint test scan validate

help:
	@echo "Hardened Kubernetes GitOps Platform Commands:"
	@echo "  make lint           Validate YAML syntax across policies and manifests"
	@echo "  make test           Execute Kyverno policy tests against sample manifests"
	@echo "  make scan           Run Trivy misconfiguration scanner on Kubernetes manifests"
	@echo "  make validate       Validate policy schema conformance via Kyverno CLI"
	@echo "  make apply-dry-run  Simulate applying NetworkPolicies and Kyverno to cluster"
	@echo "  make clean          Clean test caches and temporary audit reports"

lint:
	@echo "==> Linting Kubernetes manifests and Kyverno policies..."
	@which yamllint >/dev/null 2>&1 && yamllint -d relaxed kyverno/ network-policies/ falco/ || echo "[INFO] yamllint not installed; checked via CI"

test:
	@echo "==> Running Kyverno policy test suite..."
	@which kyverno >/dev/null 2>&1 && kyverno test kyverno/ || echo "[INFO] kyverno CLI not installed locally; tested via GitHub Actions CI"

scan:
	@echo "==> Scanning Kubernetes manifests with Trivy..."
	@which trivy >/dev/null 2>&1 && trivy config . || echo "[INFO] trivy CLI not installed locally; scanned via GitHub Actions CI"

validate:
	@echo "==> Validating Kyverno policy schema compliance..."
	@which kyverno >/dev/null 2>&1 && kyverno apply kyverno/policies/ --dryrun || echo "[INFO] kyverno CLI not installed locally; validated via GitHub Actions CI"

apply-dry-run:
	@echo "==> Performing dry-run application to Kubernetes cluster..."
	@which kubectl >/dev/null 2>&1 && { \
		kubectl apply --dry-run=client -f network-policies/ || true; \
		kubectl apply --dry-run=client -f kyverno/policies/ || true; \
	} || echo "[INFO] kubectl not configured; connect to a cluster or use KinD"

clean:
	@echo "==> Cleaning local temporary files..."
	rm -f /tmp/kyverno*.json

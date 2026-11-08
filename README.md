# Hardened Kubernetes GitOps Platform

[![K8s Compliance Audit](https://github.com/huy8114644/hardened-k8s-gitops-platform/actions/workflows/policy-compliance-audit.yml/badge.svg)](https://github.com/huy8114644/hardened-k8s-gitops-platform/actions/workflows/policy-compliance-audit.yml)
[![Kyverno: Enforce](https://img.shields.io/badge/Kyverno-Enforce-326ce5.svg)](https://kyverno.io)
[![PSS: Restricted](https://img.shields.io/badge/PSS-Restricted-success.svg)](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
[![Zero Trust: Calico](https://img.shields.io/badge/NetworkPolicy-Zero%20Trust-orange.svg)](https://projectcalico.docs.tigera.io)
[![Runtime: Falco](https://img.shields.io/badge/Falco-eBPF%20Enabled-00a871.svg)](https://falco.org)

Production-grade **Kubernetes Security Hardening and GitOps Architecture** implementing Zero-Trust network policies, Pod Security Standards (PSS Restricted) via Kyverno Policy-as-Code, and real-time eBPF runtime threat detection using Falco.

---

## 🏛️ Security Architecture

```
                     [ Internet / Edge ]
                              │
                              ▼
                [ Ingress Controller (mTLS) ]
                              │
                              ▼
  ┌─────────────────────────────────────────────────────────┐
  │  Production Namespace (Zero-Trust Calico NetworkPolicy) │
  │                                                         │
  │   [ Pod A: Payment API ] ──mTLS──> [ Pod B: Order DB ]  │
  │          │                                              │
  │          ▼                                              │
  │   [ Kyverno Admission Controller ]                      │
  │   • Disallow Privileged Containers                      │
  │   • Enforce Non-Root UID (65532)                        │
  │   • Read-Only Root Filesystem                           │
  │   • Drop ALL Linux Capabilities                         │
  │                                                         │
  │   [ Falco eBPF Runtime Detection ]                      │
  │   • Alert on Shell Spawn (bash/sh)                      │
  │   • Detect Sensitive File Access (/etc/shadow)          │
  └─────────────────────────────────────────────────────────┘
```

---

## 🔒 Security Modules

### 1. Kyverno Policy as Code (`kyverno/policies/`)
- `disallow-privileged-containers.yaml`: Rejects any container setting `privileged: true`.
- `require-run-as-non-root.yaml`: Enforces `runAsNonRoot: true` at the Pod and Container spec level.
- `require-readonly-rootfs.yaml`: Forces all containers to run with an immutable, read-only root filesystem.
- `require-drop-all-capabilities.yaml`: Drops all kernel capabilities by default.

### 2. Zero-Trust Network Policies (`network-policies/`)
- `default-deny-all.yaml`: Enforces default-deny on both Ingress and Egress for the entire namespace.
- `allow-kube-dns-egress.yaml`: Explicitly allowlists UDP/TCP port 53 to CoreDNS.

### 3. Falco Runtime Threat Detection (`falco/rules/`)
- Real-time kernel event monitoring via eBPF probes.
- Immediately flags RCE attempts, unauthorized terminal execution, or container escape attempts.

---

## 📄 License
This repository is licensed under the MIT License.


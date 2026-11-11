# Contributing

Create a focused branch such as `fix/namespace-selector` from current `main` and open a GitHub pull request. Use Conventional Commits: `feat:`, `fix:`, `docs:`, `test:`, `ci:` or `chore:` followed by a concrete behavior change.

Before review, run `make lint`, `make test` and `make scan`. Missing tools or security findings are failures, not skipped passes. Document unresolved findings. For admission changes, add allowed and denied Pod fixtures; for networking changes, describe namespace/label selection and verify packet flows on an enforcing CNI. Falco changes need engine validation on the target version.

Explain the threat/use case, changed behavior, rollout/rollback and remaining limits. Link any issue, the tested commit SHA and its GitHub Actions run. Include command results or CI artifacts; never post credentials or private inventory. Do not invent audit scores, approvals or historical merge requests.

Merge only after actual review and required checks pass. Retain the PR discussion and pipeline links as evidence. Re-run checks after modifying the proposed commit; a green badge for an older commit is not evidence for the current change.

# Tests

Checks run by CI on every pull request (added in Phase 4):

- Repository shape: known categories, fixed depth, unit contracts, README present.
- No cluster-specific value in `platform/` or `apps/`.
- Every overlay renders (`kustomize build`) and is valid (`kubeconform`).
- Manifests pass the Kyverno policies (`kyverno test`).
- `ansible-lint`, `yamllint`, file size limit.

Platform upgrades are tried first in a throwaway k3d cluster.

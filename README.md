# cluster_infra

Source of truth for the production Kubernetes cluster: machines, cluster
composition, shared platform services and apps. The cluster rebuilds from
this repo + Ansible + Bitwarden alone.

## Layers

Each layer may only rely on the layers below it.

| Layer | Folder | Owns |
| --- | --- | --- |
| 1. Machines | `ansible/` | OS baseline, k3s install, per-cluster inventories |
| 2. Clusters | `clusters/<name>/` | Bootstrap, which components and apps run, every cluster-specific value |
| 3. Platform | `platform/<category>/<component>/` | Shared services, cluster-agnostic |
| 4. Apps | `apps/<app>/` | Workloads: `base/` + one overlay per environment |

Supporting folders: `runbooks/` (manual procedures), `docs/adr/`
(architecture decisions), `tests/` (render, policy and smoke tests).

## Rules

The full rule set is in [docs/adr/0002_repository_layout.md](docs/adr/0002_repository_layout.md).
The short version:

- No secret values in this repo, ever: only references to Bitwarden.
- Nothing applied by hand outside `clusters/<name>/bootstrap/`.
- Every change to `main` goes through a pull request.

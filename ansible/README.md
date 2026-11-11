# Layer 1: Machines

Prepares the nodes and installs k3s. Everything inside Kubernetes is
handled by GitOps (layers 2 to 4), not here.

| Folder | Holds |
| --- | --- |
| `inventories/<cluster>/` | Hosts and variables for one cluster (`eu1` now, `us1` later) |
| `roles/<role>/` | Standard Ansible roles: `baseline`, `k3s_server` |
| `playbooks/` | Entry points, e.g. `site.yaml` runs every role on every host |

Rules:

- Idempotent: running a playbook twice in a row changes nothing the second time.
- Secrets are read from Bitwarden Secrets Manager at run time, never stored here.
- Provider firewalls and VPS reinstalls stay manual: see `runbooks/nodes/`.

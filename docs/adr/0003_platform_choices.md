# 0003: Platform choices for the eu1 cluster

Status: Accepted (2026-11-11)

## Context

A training cluster (par1 + waw1) proved most of the stack. The production
cluster runs your own apps first, with client apps possibly later, on a
budget of 3 VPS + free tiers.

## Decision

| Area | Choice |
| --- | --- |
| Nodes | par1, waw1, gra1; all three run the control plane and etcd |
| Node setup | Ansible; provider firewalls manual |
| Distribution | k3s, Cilium replacing flannel and kube-proxy, WireGuard between nodes |
| GitOps | Argo CD, ApplicationSets generated from this repo's folders |
| Web entry | Cloudflare Tunnel, a connector on every node; no 80/443 open |
| Admin access | Cloudflare Access; SSH tunnels as break-glass |
| Secrets | External Secrets + Bitwarden Secrets Manager (Platform, Staging, Prod) |
| Policies | Kyverno |
| Databases | CloudNativePG, 2 copies per app in prod, continuous archiving |
| Backups | Cloudflare R2, copied to Backblaze B2 (Object Lock) |
| Observability | VictoriaMetrics, VictoriaLogs, Grafana; external dead man's switch |
| Deploys | CI builds to GHCR, commits staging tags, opens prod PRs |
| Upgrades | Renovate; kured for kernel reboots; platform tested in k3d first |

## Consequences

- The cluster survives losing any one node with no action.
- Full rebuild target: under 2 hours from Git + Ansible + Bitwarden.
- Cloudflare is a single provider for DNS, entry and backups; the B2 copy
  and break-glass SSH access limit that risk.

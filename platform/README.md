# Layer 3: Platform

Shared services, written once and reused by every cluster. Nothing here
names a cluster, a domain, a node or an app: those values live in
`clusters/<name>/values/`.

## Categories (closed list)

| Category | Components |
| --- | --- |
| `networking/` | cilium, traefik, cloudflared |
| `security/` | external_secrets, kyverno, cert_manager |
| `data/` | cnpg, barman_cloud |
| `observability/` | victoria_metrics, victoria_logs, dashboards |
| `operations/` | kured |

Adding a category requires an ADR in `docs/adr/`.

## Component contract

Every `platform/<category>/<component>/` has exactly:

| Path | Holds |
| --- | --- |
| `README.md` | Purpose, what it depends on, what depends on it |
| `values.yaml` | Chart settings shared by all clusters, chart version pinned |
| `config/` | Extra manifests installed with the component |

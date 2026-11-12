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
| `operations/` | argo_cd, kured |

Adding a category requires an ADR in `docs/adr/`.

## Component contract

Every `platform/<category>/<component>/` has exactly (ADR 0004):

| Path | Holds |
| --- | --- |
| `README.md` | Purpose, what it depends on, what depends on it |
| `source.yaml` | The chart: `repo`, `chart`, `version`, `namespace` |
| `values.yaml` | Chart settings shared by all clusters |
| `config/` | Extra manifests installed with the component |

## How a component gets installed

A cluster lists it in `clusters/<name>/platform.yaml`. The cluster's
ApplicationSet then creates an Argo CD Application named after the folder
(dashes instead of underscores). That Application installs the chart from
`source.yaml` with `values.yaml`, then `clusters/<name>/values/<component>.yaml`
if that file exists.

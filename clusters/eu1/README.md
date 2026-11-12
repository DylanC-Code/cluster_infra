# eu1

Production cluster in Europe: par1 (Hostinger, Paris), waw1 (OVH, Warsaw),
gra1 (OVH, Gravelines). All three run the control plane and etcd.

Nodes and admin UIs live on `dylancastor.dev`; apps on their own domains.

| Path | Holds |
| --- | --- |
| `bootstrap/` | `bootstrap.sh` (the only steps run by hand), the root Application, the ApplicationSets |
| `platform.yaml` | Platform components running on eu1 |
| `apps.yaml` | Apps and environments running on eu1 |
| `values/` | eu1's settings for each component |

Bootstrap procedure: `runbooks/cluster/bootstrap.md`.

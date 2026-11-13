# Layer 2: Clusters

The composition root: one folder per cluster, plus `_shared/` for what every
cluster uses. It is the only place that references both `platform/` and
`apps/`, and the only place holding values specific to one cluster
(domains, node names, sizes).

Each `clusters/<name>/` has exactly:

| Path | Holds |
| --- | --- |
| `bootstrap/` | What is applied by hand once (`bootstrap.sh`: Cilium, Argo CD, the root app), plus the ApplicationSets Argo CD then keeps in sync |
| `platform.yaml` | Which platform components run on this cluster |
| `apps.yaml` | Which apps and environments run on this cluster |
| `values/<component>.yaml` | This cluster's settings for each component |

Adding a cluster = adding a folder here and an inventory in `ansible/`.

## Contents

- `<name>/`: one folder per cluster (`eu1/`, later `us1/`).
- `_shared/`: scripts every cluster uses, such as how a component becomes a
  Helm release (`component.sh`). Not a cluster: the `_` prefix says so.

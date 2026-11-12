# 0004: Each component declares its chart in source.yaml

Status: Accepted (2026-11-12). Amends rules 3 and 5 of 0002.

## Context

Argo CD creates one Application per platform component. Each needs the
chart's repo, name, version and target namespace. A comment in
`values.yaml` can't be read by Argo CD, and listing these in each cluster's
`platform.yaml` would pin versions per cluster, against rule 5.

## Decision

- Every component has a `source.yaml` with exactly four fields:
  `repo`, `chart`, `version`, `namespace`.
- Rule 3 becomes: a component has `README.md`, `source.yaml`,
  `values.yaml`, `config/`.
- Rule 5 becomes: a chart version lives only in its component's `source.yaml`.
- A cluster runs a component by listing `component: <category>/<component>`
  in `clusters/<name>/platform.yaml`. One ApplicationSet per cluster combines
  that list with each `source.yaml`.
- The Helm release and the Application are named after the component
  folder, with dashes (`argo_cd` → `argo-cd`).
- Bootstrap scripts read the same `source.yaml`, so Argo CD adopts what they
  installed.

## Consequences

- Upgrading a chart is one line, and every cluster gets it. A cluster can't
  lag behind; upgrades are tested in k3d first instead.
- Renovate needs a custom rule to find versions in `source.yaml`.

# 0005: A component's dashboards in their own values file

Status: Accepted (2026-11-16). Amends rule 3 of 0002 (as amended by 0004).

## Context

Choosing a chart's dashboards is a concept of its own: a list of names,
each turned on or off, unrelated to how the component runs. In
`victoria_metrics`, that list is ~25 lines, and `values.yaml` was already
at 149 of rule 10's 150. Rule 10 asks to split a file by concept, but a
component had a single values file.

## Decision

- A component may have a `dashboards.yaml`: Helm values, like
  `values.yaml`, holding only which dashboards it gives Grafana.
- Argo CD reads, in this order: the component's `values.yaml`, its
  `dashboards.yaml`, then the cluster's `values/<component>.yaml`. The
  bootstrap script and the checks use the same order
  (`clusters/_shared/component.sh`).
- Rule 3 becomes: a component has `README.md`, `source.yaml`,
  `values.yaml`, and optionally `config/` and `dashboards.yaml`.

## Consequences

- A component's dashboards are found in one place, by the same name in
  every component.
- Another concept that outgrows `values.yaml` needs its own ADR: values
  files are not split freely, so a component stays easy to read.

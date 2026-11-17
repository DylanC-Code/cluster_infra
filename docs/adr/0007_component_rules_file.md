# 0007: A component's alert rules in their own values file

Status: Accepted (2026-11-17). Amends rule 3 of 0002, like 0005.

## Context

A chart's default alert rules don't all fit this platform: a threshold
tuned for one data centre, recording rules for settings we don't use. As
with dashboards (ADR 0005), choosing them is a concept of its own, and
`victoria_metrics/values.yaml` has no room left under rule 10.

## Decision

- A component may have a `rules.yaml`: Helm values holding only which of
  its chart's alert and recording rules are on or off.
- A rule turned off because it doesn't fit, rather than because it's
  useless, gets its replacement in the component's `config/`, as its own
  rule, with the reason beside it.
- Argo CD reads, in this order: `values.yaml`, `dashboards.yaml`,
  `rules.yaml`, then the cluster's `values/<component>.yaml`
  (`clusters/_shared/component.sh` does the same).
- Rule 3 becomes: a component has `README.md`, `source.yaml`,
  `values.yaml`, and optionally `config/`, `dashboards.yaml` and
  `rules.yaml`.

## Consequences

- Every change to the chart's rules is in one file, so an upgrade of the
  chart is checked against one list.
- Like 0005, this doesn't open values files to any concept: another one
  needs its own ADR.

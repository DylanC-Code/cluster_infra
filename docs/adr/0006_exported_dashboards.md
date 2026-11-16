# 0006: Dashboards of our own are exported JSON, outside the line limit

Status: Accepted (2026-11-16). Amends rule 10 of 0002.

## Context

Most dashboards come from charts (ADR 0005). Some are our own, like the
cluster overview Grafana opens first. Grafana stores a dashboard as JSON:
a few panels are already several hundred lines, so rule 10 (files under
~150 lines) can't hold. Written by hand in YAML and converted by Helm, it
would stay short only by having few panels, and be harder to change than
in Grafana's editor.

## Decision

- A dashboard of our own is built in Grafana's UI, exported as JSON, and
  kept in its component's `config/` as `<name>.dashboard.json`, turned into
  a ConfigMap Grafana's sidecar loads (`kustomization.yaml`).
- Like lock files, those files are written by a tool: the line check skips
  them. Every other file keeps rule 10.
- A change is made in Grafana, exported (Share, Export, JSON), and
  committed. A change saved only in Grafana is lost at its next restart.

## Consequences

- A dashboard's diff is read in Grafana's terms (panels, queries), not as
  prose: review it by importing it, or by its queries.
- A dashboard names no cluster, node or domain (rule 4), like any
  platform file.

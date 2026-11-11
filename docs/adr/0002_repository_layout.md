# 0002: Repository layout and rules

Status: Accepted (2026-11-11)

## Context

Infra repos tend to grow into many folders at the same level with no rule
about what goes where. This repo must stay readable as apps, components and
a second cluster (US) are added.

## Decision

Four layers, each relying only on the layers below it:

1. `ansible/`: machines (OS baseline, k3s install).
2. `clusters/<name>/`: composition root (bootstrap, what runs, cluster values).
3. `platform/<category>/<component>/`: shared, cluster-agnostic services.
4. `apps/<app>/`: workloads, `base/` + `overlays/<env>/`.

Rules:

1. Fixed depth: layer / category / unit / files, nothing deeper.
2. Closed categories: `platform/` has networking, security, data,
   observability, operations; a new one needs an ADR.
3. Unit contract: a component has `README.md`, `values.yaml`, `config/`;
   an app has `README.md`, `base/`, `overlays/staging/`, `overlays/prod/`.
4. Dependency rule: `platform/` never names a cluster, domain, node or app;
   `apps/` never touches platform files; only `clusters/<name>/` references both.
5. One decision, one place: a domain lives only in `clusters/<name>/values/`,
   a chart version only in its component.
6. Environments are folders, never branches.
7. Nothing applied by hand outside `clusters/<name>/bootstrap/`; every step
   is in a runbook.
8. No secret values: only ExternalSecret references to Bitwarden.
9. Every version pinned; Renovate proposes bumps.
10. Files under ~150 lines; one manifest file per resource kind.
11. App source code lives in each app's own repo.
12. Folders and files in snake_case; Kubernetes resource names in lowercase
    with dashes (a Kubernetes rule).

## Consequences

- Adding an app: copy `apps/_template/`, add one line to `apps.yaml`.
- Adding the US cluster: `ansible/inventories/us1/` + `clusters/us1/`,
  without touching `platform/` or `apps/`.
- CI enforces the shape and the dependency rule (Phase 4).

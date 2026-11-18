# 0008: An app's staging is optional

Status: Accepted (2026-11-17). Amends rule 3 of 0002.

## Context

Rule 3 asked every app for `overlays/staging/` and `overlays/prod/`. Some
apps have no use for a staging copy (a static site, checked before it is
built), and an overlay kept only to satisfy the check is never tested and
drifts from prod.

## Decision

- An app has `README.md`, `base/` and `overlays/prod/`; `overlays/staging/`
  only when it has a staging environment.
- What runs is still decided by `clusters/<name>/apps.yaml` alone, and its
  check refuses an environment the app has no overlay for.

## Consequences

- Adding staging to an app later is one folder and one line of
  `apps.yaml`, reviewed like any change.

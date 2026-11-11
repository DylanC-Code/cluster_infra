# Layer 4: Apps

Your workloads, one folder per app. App source code lives in each app's own
repo; this folder only says which image runs where and how.

## App contract

Every `apps/<app>/` has exactly:

| Path | Holds |
| --- | --- |
| `README.md` | What the app is, its domains, its database, its secrets |
| `base/` | Deployment, service, route, database, external secrets: identical in every environment |
| `overlays/staging/` | What differs in staging: image tag, replicas, domain, quotas |
| `overlays/prod/` | What differs in prod |

Rules:

- Environments are folders, never branches.
- An app never touches platform files.
- Secret keys follow `<app>_<purpose>` and are identical in Staging and Prod.

Start a new app by copying `_template/`, then add it to `clusters/<name>/apps.yaml`.

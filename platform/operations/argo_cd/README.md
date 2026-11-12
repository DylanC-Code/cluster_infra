# argo_cd

GitOps: keeps every cluster in the state this repo describes, and repairs
any change made by hand.

Depends on: cilium (its pods need the pod network).
Depended on by: every other component and app, all deployed as Argo CD
Applications.

Installed once by hand with `clusters/<name>/bootstrap/bootstrap.sh`, then
manages itself (Application `argo-cd`).

Web UI: `kargo`, then https://localhost:8080, user `admin`
(Bitwarden: `eu1 · Argo CD · admin`). Behind Cloudflare Access from Phase 7.

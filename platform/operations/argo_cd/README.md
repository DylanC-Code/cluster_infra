# argo_cd

GitOps: keeps every cluster in the state this repo describes, and repairs
any change made by hand.

Depends on: cilium (its pods need the pod network).
Depended on by: every other component and app, all deployed as Argo CD
Applications.

Installed once by hand with `clusters/<name>/bootstrap/bootstrap.sh`, then
manages itself (Application `argo-cd`).

Web UI: at the hostname of `clusters/<name>/values/argo_cd.yaml`, behind
Cloudflare Access, then user `admin` (Bitwarden: `<cluster> · Argo CD ·
admin`). It serves plain HTTP: Cloudflare's edge ends TLS, Traefik routes
to it (HTTPRoute `argocd-server`).
Break-glass, without Cloudflare: `kargo`, then http://localhost:8080.

Bootstrap installs it without its HTTPRoute (the Gateway API types come
later, with traefik); Argo CD adds the route once they exist.

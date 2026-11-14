# traefik

Routes web requests to apps, by hostname and path. Requests come only from
cloudflared (the tunnel's connectors), over plain HTTP inside the cluster.

Routing is Gateway API only: an app exposes itself with an HTTPRoute that
attaches to the Gateway `traefik` in the namespace `traefik`. Traefik's
own IngressRoutes and Ingresses are turned off.

Runs 3 copies spread over the nodes, with a disruption budget: a drain
never stops more than one.

`config/` installs, after the chart:
- the standard Gateway API types, at the version the chart's release notes
  ask for (`kustomization.yaml`; bump it with the chart when they say so);
- the GatewayClass `traefik` and the Gateway `traefik` (port 8000, HTTP).

Depends on: cilium.
Depended on by: cloudflared (sends it every request), every app with a
route. App namespaces accept Traefik's requests: kyverno's default-isolation
lets them in.

Settings specific to each cluster: `clusters/<name>/values/traefik.yaml`
(the pod range whose forwarded headers are trusted).

# cloudflared

The cluster's end of the Cloudflare Tunnel: each connector opens encrypted
connections out to Cloudflare (port 7844), and receives through them every
request for the cluster's domains, already decrypted by Cloudflare's edge.
It passes them to Traefik as plain HTTP. No node opens 80 or 443.

One connector per node (a DaemonSet): with any node down, Cloudflare sends
requests to the others. A drain leaves it running until the node stops,
so it needs no disruption budget.

The tunnel is managed in Cloudflare (Zero Trust, Networks, Tunnels): its
routes live there, one wildcard per domain to
`http://traefik.traefik.svc.cluster.local:80`. Which hostname goes where is
decided by the HTTPRoutes in Git, not by the tunnel.

Its token is read from Bitwarden (Platform project) into the Secret
`cloudflared`; the key is the cluster's, in
`clusters/<name>/values/cloudflared.yaml`. A new token reaches the pods
only when they restart: after a rotation,
`kubectl -n cloudflared rollout restart daemonset cloudflared`.

Rendered by bjw-s's app-template, a generic chart: Cloudflare's own
(cloudflare-tunnel-remote) is unmaintained, runs a Deployment and takes
the token as a plain value.

Depends on: cilium, external_secrets (its token), traefik (where it sends
requests).
Depended on by: every public or Access-protected hostname.

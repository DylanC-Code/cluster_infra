# grafana

Dashboards and metric queries for the cluster, behind Cloudflare Access
at the hostname of `clusters/<name>/values/grafana.yaml`, then its own
admin login (password from Bitwarden, Secret `grafana-admin`).

What it shows comes from Git, never from clicks in the UI: the
`victoria_metrics` component publishes the VictoriaMetrics data source and
the dashboards as ConfigMaps, which Grafana's sidecars load. A dashboard
changed in the UI is lost at the next restart: change it in Git.

One copy, no database: its own state (users, preferences) is a SQLite file
in the pod. After a node loss it restarts elsewhere within minutes with
every dashboard, having only forgotten preferences. Alerting doesn't go
through Grafana, so it never waits for it.

Break-glass, without Cloudflare: `kgrafana`, then http://localhost:3000.

Depends on: victoria_metrics (data source, dashboards), traefik (its route),
external_secrets (its admin password).
Depended on by: nothing; it only reads.

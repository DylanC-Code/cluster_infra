# grafana

Dashboards and metric queries for the cluster, behind Cloudflare Access
at the hostname of `clusters/<name>/values/grafana.yaml`, then its own
admin login (password from Bitwarden, Secret `grafana-admin`).

What it shows comes from Git, never from clicks in the UI: the
`victoria_metrics` component publishes the VictoriaMetrics data source and
the dashboards as ConfigMaps, `victoria_logs` its data source, which
Grafana's sidecars load. The VictoriaLogs plugin is downloaded from
grafana.com at each start. A dashboard changed in the UI is lost at the
next restart: change it in Git.

Its home page is its own dashboard, the cluster overview
(`config/overview.dashboard.json`): nodes, alerts and pods at a glance,
each node's CPU, memory and disk, recent restarts, and log lines that
mention an error. To change it: edit it in Grafana, export it as JSON
(Share, Export), replace the file, commit (ADR 0006).

One copy, no database: its own state (users, preferences) is a SQLite file
in the pod. After a node loss it restarts elsewhere within minutes with
every dashboard, having only forgotten preferences. Alerting doesn't go
through Grafana, so it never waits for it.

Break-glass, without Cloudflare: `kgrafana`, then http://localhost:3000.

Depends on: victoria_metrics (data source, dashboards), victoria_logs (data
source), traefik (its route), external_secrets (its admin password).

# victoria_logs

Keeps every pod's logs for 14 days and answers searches on them, from
Grafana (Explore, data source VictoriaLogs) in LogsQL. The lines come
from the `victoria_logs_collector` component, one agent per node.

Two independent servers (`victoria-logs-0` and `-1`), each with every line:
the collector writes to both. One lost, the other answers everything; when
it returns, the collector replays what it missed from its buffer on disk.
Which nodes may hold a copy is the cluster's choice, in
`clusters/<name>/values/victoria_logs.yaml`.

Retention: 14 days, or 8 GiB per copy if that comes first (the oldest days
go). Logs are a debugging aid, not a record: they have no backup.

Break-glass, without Grafana:
`kubectl -n monitoring port-forward svc/victoria-logs 9428`, then
http://localhost:9428/select/vmui.

Depends on: victoria_metrics (scrapes its metrics), grafana (shows it).
Depended on by: victoria_logs_collector (where it sends the lines).

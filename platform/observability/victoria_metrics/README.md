# victoria_metrics

The cluster's metrics and alerts, from VictoriaMetrics' k8s stack: its
operator, node-exporter on each node, kube-state-metrics, and:

| Part | Copies | Role |
| --- | --- | --- |
| vmagent | 2 | scrape every target, both the same ones |
| vminsert | 2 | receive samples, write each to 2 vmstorage |
| vmstorage | 3, one per node | keep 30 days, on the node's own disk |
| vmselect | 2 | answer queries, merging and deduplicating |
| vmalert | 2 | evaluate the alert rules |
| alertmanager | 2, clustered | group alerts and send one notification |

Every part survives losing a node: storage replicates itself (2 copies of
each sample), so it needs no replicated disk. The two agents scrape the
same targets; duplicates are dropped (one sample per 30 s).

k3s runs etcd, the controller manager and the scheduler in its own
process: the `k3s_server` role exposes their metrics, scraped at the nodes'
addresses (`clusters/<name>/values/victoria_metrics.yaml`).

Alert rules: the chart's default set (Kubernetes, nodes, etcd...). Where
alerts are sent, and the dead man's switch: Phase 9, step 2.
Grafana and dashboards: Phase 9, step 3.

Depends on: cilium, coredns.
Depended on by: every alert, Grafana.

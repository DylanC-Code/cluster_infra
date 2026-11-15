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

k3s runs the API server, scheduler, controller manager and kubelet in one
process, with one shared set of metrics that each of their endpoints serves
again (~180,000 series each). Each metric is read once: from the API
server's endpoint, minus the biggest histograms no rule reads; the
kubelet's keeps only its own. Scraping all four tripled the series count
(2.2 million) and got vmstorage killed for lack of memory. etcd's own
metrics come from the nodes' addresses, exposed by the `k3s_server` role
(`clusters/<name>/values/victoria_metrics.yaml`).

Alert rules: the chart's default set (Kubernetes, nodes, etcd...). Where
alerts are sent, and the dead man's switch: Phase 9, step 2.
Grafana and dashboards: Phase 9, step 3.

Depends on: cilium, coredns.
Depended on by: every alert, Grafana.

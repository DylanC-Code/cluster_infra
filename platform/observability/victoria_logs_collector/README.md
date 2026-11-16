# victoria_logs_collector

One agent per node (vlagent, a DaemonSet) reads the logs of the node's
pods from `/var/log/pods`, adds their namespace, pod, container and labels,
and sends every line to both VictoriaLogs servers (`victoria_logs`).

While a server is down, its lines wait on the node's disk, in
`/var/lib/vl-collector` (at most 1 GiB per server), and are sent when it
comes back: neither copy misses anything. Past 1 GiB, the oldest lines
waiting for that server are dropped; the other server still has them.

It runs on every node, tolerating every taint: a node's logs can only be
read from that node.

Depends on: victoria_logs (where it sends the lines), victoria_metrics
(scrapes its metrics).
Depended on by: nothing.

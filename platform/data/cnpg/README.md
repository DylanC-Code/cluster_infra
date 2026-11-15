# cnpg

CloudNativePG: runs each app's PostgreSQL as a `Cluster` resource, a
primary and its replicas on other nodes, and promotes a replica on its own
when the primary's node is lost.

Two operator copies on different nodes, one leading: losing a node never
leaves the cluster without someone to run a failover.

Backups (continuous WAL archiving and base backups to R2) are the Barman
Cloud plugin's: `barman_cloud`, in the same namespace (the plugin must
run beside the operator).

Depends on: cilium.
Depended on by: barman_cloud, every app with a database.

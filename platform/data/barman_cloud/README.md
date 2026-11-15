# barman_cloud

The Barman Cloud plugin of CloudNativePG: for each database that asks for
it, sends every WAL file to object storage as soon as it is written, and
a base backup on schedule. Together they restore a database to any second
of the retention window.

Runs in `cnpg-system`, beside the operator (the plugin must). Each
database's own backup settings (its `ObjectStore`: bucket, keys from
Bitwarden, retention) live with the database, not here. The archiving
itself runs in a sidecar the plugin adds to each database pod: while this
deployment is away (its node lost), existing databases keep archiving;
only new database pods wait for it.

Depends on: cnpg, cert_manager (its TLS certificates).
Depended on by: every database's backups.

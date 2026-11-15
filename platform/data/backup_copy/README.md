# backup_copy

Copies the cluster's backup buckets from R2 to their twins on Backblaze B2,
every hour: the off-site copy that survives losing R2, or the whole
Cloudflare account. Which pairs, and the R2 address, are the cluster's
(`clusters/<name>/values/backup_copy.yaml`).

`rclone copy`, never `sync`: new and changed files go to B2, nothing is
ever deleted there by this job. The B2 buckets do the rest themselves:
- Object Lock, Compliance, 30 days: no one (no key, not even the account
  owner) can delete or overwrite a file for 30 days after it arrives;
- a lifecycle rule hides each file after 31 days and deletes it a day
  later, so B2 doesn't grow forever.
So Postgres can be restored from B2 to any moment of the last 30 days, and
any etcd snapshot of the last 30 days is there.

Keys (Bitwarden, Platform project, names in the cluster's values): an R2
token that can only read the two buckets, and a B2 application key. The
B2 web interface can't limit a key to two buckets, so it covers the
account's buckets; the Compliance lock is what protects the copies, keys
or no keys.

Rendered by bjw-s's app-template (a CronJob), as cloudflared is.

Run it now, rather than waiting for the hour:
`kubectl -n backup-copy create job --from=cronjob/backup-copy manual-$(date +%s)`

Depends on: external_secrets (its keys).
Depended on by: the off-site copy of every backup (barman_cloud, etcd).

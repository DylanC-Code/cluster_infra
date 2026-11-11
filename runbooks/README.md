# Runbooks

Manual procedures: what automation doesn't cover, and what to do when
things break. Each runbook is updated after it's used or drilled.

| Folder | Holds |
| --- | --- |
| `nodes/` | VPS reinstall, provider firewalls, running the Ansible playbook |
| `cluster/` | Bootstrap, k3s and platform upgrades, break-glass access |
| `recovery/` | Restoring etcd, Postgres, a lost node, the whole cluster |
| `drills/` | Drill procedures and the log of each drill's results |

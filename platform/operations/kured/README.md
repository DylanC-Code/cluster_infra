# kured

Reboots nodes after an update that needs it (a new kernel), one at a
time: unattended-upgrades installs updates every day but never reboots
(ansible/roles/baseline), and leaves /var/run/reboot-required. kured
drains the node, reboots it, waits for it to settle, then lets the next
one go. With 3 control plane nodes, etcd always keeps 2 of its 3 members.

Window: 03:00 to 06:00, Europe/Paris, every day. A drain that can't
finish in 15 minutes (a disruption budget holding the last copy of
something) is abandoned without forcing: the node goes back in service
and is retried at the next check.

Each node shows its state in annotations (weave.works/kured-*).

Depends on: cilium.
Depended on by: nothing; every component's disruption budget is what it
respects.

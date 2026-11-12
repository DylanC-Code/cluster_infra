# cilium

Pod networking for every cluster:
- gives pods their IPs;
- routes Services in eBPF (replaces kube-proxy);
- encrypts traffic between nodes with WireGuard (UDP 51871, the only port it uses between nodes);
- shows live traffic with Hubble.

Depends on: k3s started without flannel, network policy or kube-proxy (`ansible/roles/k3s_server`).
Depended on by: everything; no pod starts before Cilium is up.

Installed first, by hand: `clusters/<name>/bootstrap/cilium.sh`, which Argo CD then adopts.
Settings specific to each cluster: `clusters/<name>/values/cilium.yaml`.

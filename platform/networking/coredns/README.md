# coredns

The cluster's DNS: every pod resolves Service names (and the internet)
through it, at the address kubelet hands every pod
(`clusters/<name>/values/coredns.yaml`).

Runs 3 copies spread over the nodes, with a disruption budget: losing a
node leaves two answering. k3s ships its own CoreDNS with a single copy and
no setting to change it, so k3s's is disabled (`k3s_server` role) and this
one replaces it, under the same names (Service `kube-dns`, label
`k8s-app: kube-dns`). Found by the node-stop test of Phase 7: with the only
copy on the stopped node, the whole cluster lost DNS for about 5 minutes.

Installed by `clusters/<name>/bootstrap/bootstrap.sh` right after Cilium,
before Argo CD (which needs DNS to reach Git), then managed by Argo CD.

Depends on: cilium.
Depended on by: every pod.

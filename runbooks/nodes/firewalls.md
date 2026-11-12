# Provider firewalls

Two layers protect each node:

1. **Provider firewall** (this runbook, set by hand in each panel): drops
   unwanted traffic before it reaches the node.
2. **Node firewall** (nftables, set by Ansible, `baseline` role): the same
   allowlist, enforced on the node itself.

The node firewall is the one that matters: OVH's Edge Network Firewall only
filters traffic from outside the OVHcloud network, so other OVH servers
reach waw1 and gra1 unfiltered.

## Nodes

| Node | Provider | Public IP |
| --- | --- | --- |
| par1 | Hostinger | 2.24.59.184 |
| waw1 | OVH | 146.59.126.75 |
| gra1 | OVH | 193.70.85.94 |

## What is allowed

| Traffic | From |
| --- | --- |
| TCP 22 (SSH) | Anywhere |
| All TCP (k3s API, etcd, kubelet, Cilium health) | The other nodes |
| UDP 51871 (WireGuard between nodes) | The other nodes |
| ICMP | Anywhere |
| Everything else | Dropped |

No 80/443: the Cloudflare Tunnel connects outward.

## par1: Hostinger (stateful)

hPanel → VPS → Security → Firewall. Replies to outgoing traffic are allowed
automatically. Rules, in order:

| Action | Protocol | Port | Source |
| --- | --- | --- | --- |
| Accept | TCP | 22 | Any |
| Accept | TCP | Any | 146.59.126.75 |
| Accept | TCP | Any | 193.70.85.94 |
| Accept | UDP | 51871 | 146.59.126.75 |
| Accept | UDP | 51871 | 193.70.85.94 |
| Accept | ICMP | Any | Any |
| Drop | Any | Any | Any |

## waw1 and gra1: OVH Edge Network Firewall (stateless)

OVH Control Panel → Network → Public IP addresses → the node's IP →
Edge Network Firewall. Up to 20 rules, priorities 0 to 19, the first match
wins. Stateless: replies to outgoing traffic need their own rules (3, 5, 6).

Only par1 needs rules: traffic between waw1 and gra1 never leaves the
OVHcloud network, so this firewall doesn't see it.

| Priority | Action | Protocol | Source | Ports / option |
| --- | --- | --- | --- | --- |
| 0 | Authorise | TCP | 2.24.59.184/32 | all |
| 1 | Authorise | UDP | 2.24.59.184/32 | destination 51871 |
| 2 | Authorise | TCP | all | destination 22 |
| 3 | Authorise | TCP | all | TCP status: established |
| 4 | Authorise | ICMP | all | |
| 5 | Authorise | UDP | all | source 53 (DNS replies) |
| 6 | Authorise | UDP | all | source 123 (NTP replies) |
| 19 | Refuse | IPv4 | all | |

Priorities 7 to 18 stay free for later rules.

Make sure the firewall is **Active**: rules on a disabled firewall only
apply during a DDoS attack.

## Checks

From the devcontainer (outside the cluster):

```
ssh par1 true && ssh waw1 true && ssh gra1 true && echo ssh ok
ping -c 2 par1.dylancastor.dev
```

From each node, to the two others (once the node firewall is in place too):

```
nc -zv -w 3 <other node>.dylancastor.dev 22
```

Once k3s runs (Phase 3), from the devcontainer, these must **time out**:

```
nc -zv -w 3 par1.dylancastor.dev 6443
nc -zv -w 3 waw1.dylancastor.dev 2379
nc -zv -w 3 gra1.dylancastor.dev 10250
```

A port can only be tested for real while something listens on it.

## Later

- Phase 7: cloudflared is forced to use TCP (HTTP/2), so its replies pass
  OVH's "established" rule; QUIC replies (UDP 7844) would be dropped.
- Changing a node's IP means updating both layers.

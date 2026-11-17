# Break-glass access

Reaching the cluster and its admin UIs without Cloudflare: when the edge,
the tunnel or Access is down or misconfigured, or your Access login is lost.

Everything here goes through SSH (port 22, key only), the one way in that
doesn't depend on Cloudflare.

## 1. Nodes

    ssh par1    # or waw1, gra1: user dylan, key only

- sudo password: Bitwarden Secrets Manager, project Platform,
  `eu1_<node>_sudo_password`. Or let Ansible read it: `bws_login`, then
  `ansible <node> -b -a "<command>"` from `ansible/`.
- If SSH itself fails, use the provider's console (it logs in with the
  sudo password):
  - OVH (waw1, gra1): Control Panel → Bare Metal Cloud → Virtual Private
    Servers → the VPS → KVM.
  - Hostinger (par1): hPanel → VPS → Browser terminal.
- A VPS stopped from inside is started again from its panel. OVH (this VPS
  range): Boot ⋯ → Reboot my VPS, then wait 2 to 5 minutes and refresh.

## 2. Cluster API

    ktunnel             # ssh -fN eu1-api
    kubectl get nodes

`eu1-api` (in `~/.ssh/config.d/cluster`, on your computer) forwards
`127.0.0.1:6443` to one node's API, which is what the `eu1` kubeconfig
context talks to. Every node runs the API: if that node is down, open the
tunnel through another one instead:

    ktunnel_stop
    ssh -fN -L 6443:127.0.0.1:6443 waw1

## 3. Admin UIs over port-forwards

With the API tunnel open (section 2). Ctrl+C closes a port-forward.

| UI | Command | Open | Login |
| --- | --- | --- | --- |
| Argo CD | `kargo` | http://localhost:8080 | `admin`, vault: `eu1 · Argo CD · admin` |
| Traefik dashboard | `ktraefik` | http://localhost:9000/dashboard/ | none |
| Hubble | `khubble` | http://localhost:12000 | none |

The aliases live in `.devcontainer/shell/k8s_aliases.sh`, with the
`kubectl port-forward` command each one runs.

## 4. Finding what broke on the Cloudflare side

- Tunnel: Cloudflare One → Networks → Tunnels → `eu1` should be Healthy
  with 3 connectors. In the cluster:

      kubectl -n cloudflared get pods -o wide
      kubectl -n cloudflared logs daemonset/cloudflared | grep -i "registered tunnel connection"

- Routes: tunnel `eu1` → Public hostnames: `*.dylancastor.dev` (Protect
  with Access on), `*.dylancastor.com` and `dylancastor.com` (off), all to
  `http://traefik.traefik.svc.cluster.local:80`.
- Access: Access controls → Applications → `dylancastor.dev · all`.
  Deleting or disabling it never opens the admin UIs: the tunnel still
  checks the Access token on `*.dylancastor.dev`, so they answer 403
  instead.
- Inside the cluster, a route that doesn't answer:

      kubectl get httproute -A
      kubectl -n traefik logs deploy/traefik --tail=50

- Cloudflare account locked out: its recovery codes are stored offline
  (Phase 0). Public sites stay down until it's back; the cluster itself
  keeps running and stays reachable through sections 1 to 3.

## 5. Drill

Once per drill round (Phase 12), with Cloudflare left as it is:

1. `ktunnel`, then `kubectl get nodes`: 3 Ready.
2. `kargo`: Argo CD's login page, admin login works.
3. `ktraefik` and `khubble`: both pages load.
4. Section 2's fallback: the tunnel through another node works.

Update this runbook with anything that didn't work as written.

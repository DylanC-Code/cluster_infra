# Reinstall a node

From an empty VPS to a node ready for k3s, about 20 minutes. Everything
after step 3 is done by Ansible.

## Before you start

- In the devcontainer, run `bws_login` (the Ansible token, from the vault:
  `Infra/Production/Bootstrap`, "eu1 · bws · platform reader token (ansible)").
- The node's sudo password exists in Bitwarden Secrets Manager (Platform):
  `eu1_<node>_sudo_password`, and its ID is in `ansible/inventories/eu1/host_vars/<node>.yaml`.
- The provider firewall is set: see [firewalls.md](firewalls.md).

## 1. Reinstall the VPS

| | OVH (waw1, gra1) | Hostinger (par1) |
| --- | --- | --- |
| Where | Control Panel → VPS → Reinstall | hPanel → VPS → Operating system |
| System | Ubuntu 24.04 | Ubuntu 24.04 |
| SSH key | Content of `~/.ssh/infra.pub` | Content of `~/.ssh/infra.pub` (Settings → SSH keys) |
| Other | Tick "do not receive authentication codes by email" | Root password: Bitwarden generator, 32 characters, saved in the vault under `Infra/Production/Access` |
| Default user | `ubuntu` | `root` |

## 2. DNS

Cloudflare, `dylancastor.dev`: an A record `<node>` → public IP, DNS only.
Unchanged by a reinstall unless the IP changed (then also update
`public_ip` in `host_vars/<node>.yaml` and both firewall layers).

## 3. Forget the old host key

The reinstall created a new one; SSH would refuse to connect otherwise.

```
ssh-keygen -R <node>.dylancastor.dev
```

## 4. First run: as the provider's default user

From `ansible/`:

```
ansible <node> -m ping -e ansible_user=ubuntu        # OVH
ansible <node> -m ping -e ansible_user=root          # Hostinger

ansible-playbook playbooks/site.yaml --limit <node> -e ansible_user=ubuntu   # OVH
ansible-playbook playbooks/site.yaml --limit <node> -e ansible_user=root     # Hostinger
```

This creates `dylan`, locks SSH to him, and applies the whole baseline.
The cleanup tasks are skipped on purpose: Ansible is connected as the
account they would remove.

## 5. Second run: as dylan

```
ansible-playbook playbooks/site.yaml --limit <node>
```

Removes the provider's default account and root's SSH key. Run it once
more: it must end with `changed=0`.

## 6. Checks

```
ansible <node> -a hostname
ansible <node> -b -a "nft list set inet node_firewall cluster_nodes"
ssh -o IdentitiesOnly=yes -i ~/.ssh/infra.pub root@<node>.dylancastor.dev true   # must be refused
```

Hostname = node name, the firewall lists every node's IP, root is refused.

If SSH is ever locked out: the provider's web console, logged in as
`dylan` with his sudo password from Bitwarden.

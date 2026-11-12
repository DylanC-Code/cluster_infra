# Bootstrap eu1

From nodes running k3s (`ansible/playbooks/site.yaml`) to a cluster that
Argo CD manages from Git.

## Prerequisites

- The repo pushed to `main`: Argo CD reads GitHub, not your local copy.
- Admin access from the devcontainer: `ansible-playbook playbooks/kubeconfig.yaml`
  (from `ansible/`), then `ktunnel`.

## Run

    bash clusters/eu1/bootstrap/bootstrap.sh

It installs Cilium, then Argo CD, then applies `root.yaml`. About 5 minutes.

## Check

    kubectl get nodes                       # all Ready
    kubectl -n argocd get applications      # root, cilium, argo-cd: Synced, Healthy

## Admin password

1. Read it: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo`
2. Save it in Bitwarden (vault, organization Castor, collection Infra, folder
   `Infra/Production/Break-glass`), as the Login `eu1 · Argo CD · admin`.
3. Delete the initial copy: `kubectl -n argocd delete secret argocd-initial-admin-secret`

To reset it: remove `admin.password` and `admin.passwordMtime` from the
`argocd-secret` Secret, restart `argocd-server`. A new initial secret is created.

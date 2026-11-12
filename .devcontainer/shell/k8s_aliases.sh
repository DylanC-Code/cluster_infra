#!/bin/bash
# Kubernetes shell shortcuts, for bash and zsh.
# Sourced from ~/.shellrc.d by the devcontainer (setup_shell.sh).

# ---------- kubectl ----------
alias k='kubectl'
alias kgn='kubectl get nodes -o wide'
alias kgp='kubectl get pods -A -o wide'
alias kga='kubectl get all -A'
alias kd='kubectl describe'
alias kl='kubectl logs'

# ---------- API tunnel (to eu1-api, see ~/.ssh/config.d/cluster) ----------
alias ktunnel='ssh -fN eu1-api'
alias ktunnel_stop='pkill -f "ssh -fN eu1-api"'

# ---------- Web UIs (port-forwards, Ctrl+C to close) ----------
# Argo CD: https://localhost:8080
alias kargo='kubectl -n argocd port-forward svc/argocd-server 8080:443'
# Hubble: http://localhost:12000
alias khubble='cilium hubble ui --open-browser=false'
alias kgrafana='kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80'

# ---------- Bitwarden Secrets Manager ----------
# Asks for the Ansible token without showing or recording it.
# Lives only in this shell: run it again in each new terminal.
bws_login() {
  printf 'Bitwarden token (eu1 ansible): '
  read -rs BWS_ACCESS_TOKEN && export BWS_ACCESS_TOKEN
  echo
}

# ---------- Tab completion ----------
if [ -n "${ZSH_VERSION:-}" ]; then
  # Load zsh's completion system if the dotfiles haven't already
  (( $+functions[compdef] )) || { autoload -Uz compinit && compinit; }
  source <(kubectl completion zsh)
  source <(helm completion zsh)
  source <(cilium completion zsh)
elif [ -n "${BASH_VERSION:-}" ]; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl k
  source <(helm completion bash)
  source <(cilium completion bash)
fi

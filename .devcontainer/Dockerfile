FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# System packages the tools and scripts need
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      dnsutils netcat-openbsd unzip python3-venv \
 && rm -rf /var/lib/apt/lists/*

# Versions and install scripts: one script per family of tools
COPY versions.env /tmp/devcontainer/versions.env
COPY install/ /tmp/devcontainer/install/

RUN bash /tmp/devcontainer/install/kubernetes_tools.sh
RUN bash /tmp/devcontainer/install/cluster_tools.sh
RUN bash /tmp/devcontainer/install/validation_tools.sh
RUN bash /tmp/devcontainer/install/bitwarden.sh
RUN bash /tmp/devcontainer/install/python_tools.sh \
 && rm -rf /tmp/devcontainer

# Ansible tools live in their own virtual environment
ENV PATH="/opt/python_tools/bin:${PATH}"

# Owned by vscode so the kubeconfig volume is writable
RUN mkdir -p /home/vscode/.kube && chown vscode:vscode /home/vscode/.kube

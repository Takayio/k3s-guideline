#/bin/sh

# Set Root Path
ROOT_PATH="/etc/rancher/k3s"

# Master Node Tailscale IP
MASTER_TAILSCALE_IP=
MASTER_TOKEN=

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip -4)

# Create K3s config
mkdir -p ${ROOT_PATH}

tee ${ROOT_PATH}/config.yaml <<EOF
node-ip: ${TAILSCALE_IP}
flannel-iface: "tailscale0"
kubelet-arg:
  - "--node-ip=${TAILSCALE_IP}"
EOF

# Install k3s agent
curl -sfL https://get.k3s.io | K3S_URL="https://${MASTER_TAILSCALE_IP}:6443" K3S_TOKEN="${MASTER_TOKEN}" sh -

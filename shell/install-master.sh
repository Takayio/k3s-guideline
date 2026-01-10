#/bin/sh

# Set Root Path
ROOT_PATH="/etc/rancher/k3s"

# Get Server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip -4)

# Create K3s config
mkdir -p ${ROOT_PATH}

# Create config.yaml
tee ${ROOT_PATH}/config.yaml <<EOF
node-ip: ${TAILSCALE_IP}
advertise-address: ${TAILSCALE_IP}
flannel-iface: "tailscale0"
flannel-conf: "/etc/rancher/k3s/flannel-custom.json"
disable:
  - traefik
tls-san:
  - "${TAILSCALE_IP}"
  - "${SERVER_IP}"
EOF

# Create flannel-custom.json
tee ${ROOT_PATH}/flannel-custom.json <<EOF
{
  "Network": "10.42.0.0/16",
  "Backend": {
    "Type": "vxlan",
    "MTU": 1200
  }
}
EOF

Install k3s Master Node
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init" sh -

echo "Usage:\n"
echo "export MASTER_TAILSCALE_IP=${TAILSCALE_IP}"
echo "export MASTER_TOKEN=$(cat /var/lib/rancher/k3s/server/node-token)"
echo "curl -sSL https://raw.githubusercontent.com/Takayio/k3s-guideline/main/shell/install-worker.sh | sh \n"
echo "Master Node is ready!"

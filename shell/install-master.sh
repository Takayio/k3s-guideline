#/bin/sh

# Set Root Path
ROOT_PATH="/etc/rancher/k3s"

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

# Install k3s Master Node
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init" sh -

echo "Master Node IP: ${TAILSCALE_IP}"
echo "Master Node Token: $(cat /var/lib/rancher/k3s/server/node-token)"

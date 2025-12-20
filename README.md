# Setting up K3s HA Cluster with Tailscale

## Prerequisites

- Conoha VPS (Cloud)
- Raspberry Pi (Home)
- Tailscale

## Architecture

```mermaid
graph TD
  subgraph Conoha_VPS ["Conoha VPS (Cloud)"]
    direction TB
    C_IP["Public IP: 157.x.x.x<br/>Tailscale IP: 100.76.54.126"]
    Ingress["Ingress Nginx<br/>(Controller)"]
    Flannel["Flannel Interface<br/>(flannel.1) MTU 1150"]

    Ingress --> Flannel
  end

  subgraph Tunnel ["Tailscale Mesh VPN Tunnel"]
    Packet["[ Encapsulated Packet ]<br/>(Outer: Tailscale UDP | Inner: Pod IP 10.42.x.x)"]
  end

  subgraph Raspberry_Pi ["Raspberry Pi (Home)"]
    direction TB
    R_IP["Private IP: 192.168.x.x<br/>Tailscale IP: 100.68.x.x"]
    Gatekeeper["IP Forwarding / IPTables<br/>(The 'Gatekeeper')"]
    Pod["Your Pod<br/>(10.42.6.182:80)"]

    Gatekeeper --> Pod
  end

  Flannel --> Packet
  Packet --> Gatekeeper
```

## Installation

### Update System

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### Install Tailscale on Controller and Worker

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

# Login your Tailscale Account with your Browser
```

### Install K3s Controller with Github shell

```bash
curl -sSL https://raw.githubusercontent.com/Takayio/k3s-guideline/main/shell/install-master.sh | sh
```

### Install K3s Worker with Github shell

```bash
export MASTER_TAILSCALE_IP=""
export MASTER_TOKEN=""
curl -sSL https://raw.githubusercontent.com/Takayio/k3s-guideline/main/shell/install-worker.sh | sh
```

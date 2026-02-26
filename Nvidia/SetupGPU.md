# Ubuntu Server Setup for Nvidia GPU

## Update System

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

## Check Basic Hardware

```bash
$ lspci | grep -i nvidia

01:00.0 VGA compatible controller: NVIDIA Corporation TU117 [GeForce GTX 1650] (rev a1)
```

## Check Available Drivers

最穩定首選：nvidia-driver-535-server
效能與新功能：nvidia-driver-590-server
系統推薦：nvidia-driver-590-open

```bash
$ ubuntu-drivers devices

vendor   : NVIDIA Corporation
model    : TU117 [GeForce GTX 1650]
driver   : nvidia-driver-535 - distro non-free
driver   : nvidia-driver-590-server - distro non-free
driver   : nvidia-driver-590-server-open - distro non-free
driver   : nvidia-driver-590-open - distro non-free recommended
driver   : nvidia-driver-590 - distro non-free
```

## Install Nvidia Driver

```bash
$ sudo apt install nvidia-driver-590-server
$ sudo reboot

$ nvidia-smi

Thu Feb 26 11:09:24 2026
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 590.48.01              Driver Version: 590.48.01      CUDA Version: 13.1     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce GTX 1650        Off |   00000000:01:00.0 Off |                  N/A |
| 30%   34C    P8              7W /   75W |       0MiB /   4096MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+

```

## Install Nvidia Container Toolkit

1. Install the prerequisites for the instructions below

```bash
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg2
```

1. Configure the production repository

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

1. Install the nvidia-container-toolkit

```bash
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

1. Perfer setting Persistence Mode (Optional)

```bash
sudo nvidia-smi -pm 1
```

## Install Docker

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
```

## Configure Docker

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## Verify Docker

```bash
$ docker run --rm --gpus all nvidia/cuda:12.0.1-base-ubuntu22.04 nvidia-smi

Status: Downloaded newer image for nvidia/cuda:12.0.1-base-ubuntu22.04
Thu Feb 26 06:19:30 2026
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 590.48.01              Driver Version: 590.48.01      CUDA Version: 13.1     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce GTX 1650        On  |   00000000:01:00.0 Off |                  N/A |
| 30%   34C    P8              7W /   75W |       1MiB /   4096MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
```

## Troubleshooting

### The problem of Secure Boot

在 BIOS/UEFI 中直接關閉 Secure Boot
這是大多數伺服器管理員的首選，除非你有極高的安全性規範。

1. 重啟電腦進入 BIOS/UEFI 設定（通常是按 F2, Del 或 F12）。
2. 尋找 Security 或 Boot 選項。
3. 將 Secure Boot 設為 Disabled。
4. 儲存並重啟，直接安裝驅動即可。

## Reference

- [Install Nvidia driver on Ubuntu](https://erhwenkuo.github.io/mlops/01-getting-started/learning-env/rancher/k8s-rke2-containerd-gpu/#02-gpu)
- [Install Nvidia Container Toolkit on Ubuntu](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

# Setup K3s with Nvidia GPU

1. Install GPU Operator

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia && helm repo update

# Use containerd as the container runtime
# Disable driver and toolkit installation
helm upgrade --install gpu-operator \
  -n gpu-operator --create-namespace \
  nvidia/gpu-operator \
  --set operator.defaultRuntime=containerd \
  --set driver.enabled=false \
  --set toolkit.enabled=false
```

1. Verify GPU Operator

```bash
$ kubectl get pods -n gpu-operator

NAME                                                          READY   STATUS      RESTARTS   AGE
gpu-feature-discovery-hvx94                                   1/1     Running     0          61m
gpu-operator-7569f8b499-64scg                                 1/1     Running     0          62m
gpu-operator-node-feature-discovery-gc-55ffc49ccc-hlhbl       1/1     Running     0          62m
gpu-operator-node-feature-discovery-master-6b5787f695-9bkkf   1/1     Running     0          62m
gpu-operator-node-feature-discovery-worker-5dzwj              1/1     Running     0          62m
gpu-operator-node-feature-discovery-worker-8thfv              1/1     Running     0          62m
gpu-operator-node-feature-discovery-worker-hvgz7              1/1     Running     0          62m
gpu-operator-node-feature-discovery-worker-nrkls              1/1     Running     0          62m
gpu-operator-node-feature-discovery-worker-txb4b              1/1     Running     0          62m
nvidia-cuda-validator-jwkzl                                   0/1     Completed   0          61m
nvidia-dcgm-exporter-pj448                                    1/1     Running     0          61m
nvidia-device-plugin-daemonset-nlxw7                          1/1     Running     0          61m
nvidia-operator-validator-7qx9g                               1/1     Running     0          61m
```

1. Verify GPU Setting

```bash
$ kubectl apply -f -<<EOF
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  restartPolicy: Never
  runtimeClassName: nvidia
  containers:
    - name: cuda-container
      image: nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda10.2
      resources:
        limits:
          nvidia.com/gpu: 1
  tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
EOF
```

```bash
$ kubectl logs pod/gpu-pod

[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

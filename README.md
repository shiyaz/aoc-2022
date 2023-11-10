# spark-on-k8s-operator

## Install minikube
```bash
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.5.2/minikube-linux-amd64   && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
```

## Install VirtualBox

## Install minikube
https://kubernetes.io/docs/tasks/tools/install-minikube/

## Start minikube cluster

```bash
minikube stop -p test-cluster
minikube delete -p test-cluster

# VM parameters affect only the first time (at create)
minikube \
    --memory 8192 \
    --cpus 4 \
    --disk-size='20000mb' \
    --vm-driver=virtualbox \
    -p test-cluster \
    start
```

<details>
  <summary>Logs</summary>
  
  ```bash
😄  [test-cluster] minikube v1.5.2 on Ubuntu 18.04
💿  Downloading VM boot image ...
    > minikube-v1.5.1.iso.sha256: 65 B / 65 B [--------------] 100.00% ? p/s 0s
    > minikube-v1.5.1.iso: 143.76 MiB / 143.76 MiB [-] 100.00% 82.91 MiB p/s 2s
🔥  Creating virtualbox VM (CPUs=4, Memory=8192MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.16.2 on Docker '18.09.9' ...
💾  Downloading kubelet v1.16.2
💾  Downloading kubeadm v1.16.2
🚜  Pulling images ...
🚀  Launching Kubernetes ... 
⌛  Waiting for: apiserver
🏄  Done! kubectl is now configured to use "test-cluster"
  ```
  
</details>

## Check VM is running
```bash
VBoxManage list runningvms
```
`"test-cluster" {9d06f9d7-2c61-457c-acb9-7cf5acaa62d1}`

## Check VM parameters
```bash
VBoxManage showvminfo "test-cluster" | egrep -i '(memory size|number of cpu)'
```

## Change VM parameters (if needed)
```bash
minikube -p test-cluster stop 
VBoxManage modifyvm "test-cluster" \
  --cpus 4 \
  --memory 8192

VBoxManage showvminfo "test-cluster" | egrep -i '(memory size|number of cpu)'

minikube -p test-cluster start
```

## Install kubectl
https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux

## Check all services started
```bash
kubectl -n kube-system get pod
```

## Run minikube dashboard
```bash
minikube dashboard -p test-cluster
```

## Install sparkoperator with Helm
<details>
  <summary>Helm 2</summary>

## Install Helm
https://helm.sh/docs/intro/install/
```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

## Install sparkoperator
```bash
# Install Tiller
helm init

# Wait a little bit ... then

helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm del --purge spark-example
helm install incubator/sparkoperator \
    --namespace spark-operator \
    --set sparkJobNamespace=default \
    --set enableWebhook=true \
    --name spark-example \
    --version 0.4.5
```

## Check all services are running
```bash
helm status spark-example
```
</details>

<details>
  <summary>Helm 3 (Not working yet)</summary>

## Install Helm
https://helm.sh/docs/intro/install/
```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

## Install sparkoperator
```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo update
helm del spark-example
helm install incubator/sparkoperator \
    --namespace spark-operator \
    --set sparkJobNamespace=default \
    --set enableWebhook=true \
    --set name=spark-example \
    --version 0.4.5
```

## Check all services are running
```bash
helm status spark-example
```
</details>

## Create serviceuser and assign him the role
```bash
kubectl create serviceaccount spark --namespace=default
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark
```

## Check all serviceusers can create pods
```bash
kubectl auth can-i create pod --as=system:serviceaccount:default:spark
kubectl auth can-i create pod --as=system:serviceaccount:default:spark-example-spark
kubectl auth can-i create pod --as=system:serviceaccount:spark-operator:spark-example-sparkoperator
```

## Run application
```bash
kubectl delete pod spark-pi-driver ; \
kubectl delete sparkapplication.sparkoperator.k8s.io/spark-pi ; \
kubectl apply -f examples/spark-pi.yaml
```

## View App info
```bash
kubectl get sparkapplications spark-pi -o=yaml
kubectl describe sparkapplication spark-pi
```

## View events
```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## Additional environment comands
```bash
# Get all entities
kubectl get service --all-namespaces
kubectl get namespace
kubectl get serviceaccount --all-namespaces

# Get all pods info
kubectl get pods -o yaml

# Get configmap
kubectl get configmap
```

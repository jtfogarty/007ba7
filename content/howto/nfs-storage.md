---
title: "Default Storageclass with QNAP"
date: 2020-09-18T11:11:11+06:00
author: Jeff Fogarty
tags: ["home lab", "storage","kubernetes","qnap"]
draft: false
description: "QNAP and a Kubernetes Home Lab"
type: "howto"
weight: 4
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2021-02-22 </div><p>

The goal is to configure a default storage class for pods running in my k8s home lab.

Below are the steps I used.

Each of the worker nodes must have the `nfs-common` package installed. 
```
#install nfs-common on all worker nodes 
sudo apt-get install -y nfs-common
```
Run the below on the master node, assuming [helm 3](https://helm.sh/docs/intro/install/) is already installed.
```
# add repo to helm 3
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

# The below creates the nfs namespace if it does not exist and then creates the deployment, secrets, service account, etc.  
helm install nfs-default-sc --create-namespace --namespace=nfs nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=10.10.100.18 \
    --set nfs.path=/share/mf-default-sc \
    --set storageClass.defaultClass=true \
    --set storageClass.name=mf-dv-01 \
    --set storageClass.provisionerName=mf.home.lab/nfs
```

The way objects are named is less than optimal.  With the above config, the deployment, pod, replicaset, 
secret and service account names are patterned after `nfs-default-sc-nfs-subdir-external-provisioner`

Where `nfs-default-sc` is the helm release name and `nfs-subdir-external-provisioner` 

To see helm releases for the above, run;

```    
helm list -n nfs
```
returns
```
NAME             NAMESPACE   REVISION  UPDATED         STATUS    CHART                                   APP VERSION
nfs-default-sc   nfs         1         2021-02-21 ...  deployed  nfs-subdir-external-provisioner-4.0.2   4.0.0
```

To test this default storage class execute the below;

```
cat <<EOF >./test-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 500Mi
EOF

kubectl create -f test-pvc.yaml

kubectl get pvc
```
By not using a `storageClassName:` in the yaml file, Kubernetes will use the storageclass defined as `default`.
### References
[nfs external provisioner](https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/)
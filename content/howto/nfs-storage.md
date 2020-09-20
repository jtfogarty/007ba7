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
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-20 </div><p>

The goal is to configure a default storage class for pods running in my k8s home lab.

Below are the steps I used.  I'm not a big fan of using the default namespace so I modified as appropriate.

Each of the worker nodes must have the `nfs-common` package installed. 
```
#install nfs-common on all worker nodes 
sudo apt-get install -y nfs-common
```
Run the below on the master node,
```
#clone repo
git clone https://exxsyseng@bitbucket.org/exxsyseng/nfs-provisioning.git
cd nfs-provisioning

kubectl create ns nfs

#change the namespace from default to nfs
vi rbac.yaml

kubectl create -f rbac.yaml -n nfs

#change the provisioner name to
#provisioner: dev.home.lab/nfs
vi default-sc.yaml

kubectl apply -f default-sc.yaml -n nfs

#Change the below items with your own values
#            - name: PROVISIONER_NAME
#              value: dev.home.lab/nfs
#            - name: NFS_SERVER
#              value: 10.10.100.18
#            - name: NFS_PATH
#              value: /share/CACHEDEV4_DATA/default-sc
#....
#            server: 10.10.100.18
#            path: /share/CACHEDEV4_DATA/default-sc
vi deployment.yaml 

kubectl apply -f deployment.yaml -n nfs && kubectl get po -n nfs -w
```

To test this default storage class execute the below;

```
cp 4-pvc-nfs.yaml 4-pvc-nfs-1.yaml

#delete the line 
# storageClassName: managed-nfs-storage
vi 4-pvc-nfs-1.yaml

kubectl create -f 4-pvc-nfs-1.yaml

kubectl get pvc
```
By deleting `storageClassName: managed-nfs-storage` from the yaml file, Kubernetes will use the storageclass defined as `default`.

![image](../../img/lab/sc-pvc-list.png)

Looking at the FileStation interface for the QNAP, we can see the newly created folder. (I had the current context namespace set to `jx` when I created the pvc. That is why we see `jx-pvc1-...` as the prefix.)

![image](../../img/lab/filestation.png)

### References
[Redblink.com](https://redblink.com/setup-nfs-server-provisioner-kubernetes/)<br>
[Helm Chart](https://github.com/helm/charts/tree/master/stable/nfs-server-provisioner)<br>
[Knowledia](https://news.knowledia.com/US/en/articles/deploying-dynamic-nfs-provisioning-in-kubernetes-exxact-5531d53d499daad4fb5844f863d25728b381a8cf)<br>
[Dynamic NFS](https://blog.exxactcorp.com/deploying-dynamic-nfs-provisioning-in-kubernetes/)<br>
[How to use the 'storageClass' attribute](https://itnext.io/kubernetes-tip-how-to-use-the-storageclass-attribute-75cf47e7c6b0)

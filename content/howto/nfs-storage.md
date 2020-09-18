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
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-18 </div><p>

The goal is to configure a default storage class for pods running in my k8s home lab.

Below are the steps I used.  I'm not a big fan of using the default namespace so I modified as appropriate.

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

### References
[Redblink.com](https://redblink.com/setup-nfs-server-provisioner-kubernetes/)<br>
[Helm Chart](https://github.com/helm/charts/tree/master/stable/nfs-server-provisioner)<br>
[Knowledia](https://news.knowledia.com/US/en/articles/deploying-dynamic-nfs-provisioning-in-kubernetes-exxact-5531d53d499daad4fb5844f863d25728b381a8cf)<br>
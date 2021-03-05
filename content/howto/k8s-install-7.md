---
title: "Install Kubernetes via scripts on Ubuntu"
date: 2020-09-05T11:11:11-11:11
author: Jeff Fogarty
tags: ["kubernetes","install"]
draft: false
description: "Installing Kubernetes with a script on a home lab"
type: "howto"
weight: 7
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-23 </div><p>

#### Setup

Copy the below script to each of your nodes you plan to make part of cluster and execute;

{{< gist jtfogarty d748e6ecc195045d9a8b9dc6dc37fbe9 "setup.sh">}}


#### Master Node Installation

The below script is designed to install or remove Kubernetes on a master nodes. 

Copy the master scipt to your master server (only a single master is supported) and execute

Key items to look at are;

- [ ] Line 45 - this allows Docker to pull from an unsecure local repository.  If you do not have one, you can delete this line along with the `,` at the end of line 44
- [ ] Lines 58 and 68 specifies which version of Docker and Kubernetes to install.  If you change the Kubernetes version, you must also change the version listed on line 75<br>

{{< gist jtfogarty d748e6ecc195045d9a8b9dc6dc37fbe9 "master.sh">}}

#### Worker Node Installation

Key items to look at are;

- [ ] Line 45 - this allows Docker to pull from an unsecure local repository.  If you do not have one, you can delete this line along with the `,` at the end of line 44
- [ ] Lines 58 and 68 specifies which version of Docker and Kubernetes to install.  If you change the Kubernetes version, you must also change the version listed on line 75<br>
- [ ] Line 76 must be changed with the appropriate join command.  The join command is echoed at the completion of the master script.  To create a new join command, execute `kubeadm token create --print-join-command` on the master

{{< gist jtfogarty d748e6ecc195045d9a8b9dc6dc37fbe9 "worker.sh">}}

#### Network Setup

The last piece of the puzzel for a function cluster is networking.  Below are the commands for installing Calico;

```
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
wget https://docs.projectcalico.org/manifests/custom-resources.yaml 
vi custom-resources.yaml
kubectl create -f ./k8s/install/custom-resources.yaml
```
In the `kubeadm init` command we specified the pod network CIDR to be `--pod-network-cidr=10.41.0.0/16` so when setting up Calico, we need to specify the same CIDR as below;

```
    ipPools:
    - blockSize: 26
      cidr: 10.41.0.0/16
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()
```

Calico can be installed right after the master completes 

#### Helpful commands

`kubectl get nodes -w` - returns all nodes in the cluster and let you know if the are ready.  They will remain in the `note-ready` state until Calico installed completely.  The -w is a wait flag that will continually echo the status of the nodes

`kubectl get po -A -w` - returns all `pods` from all `namespaces` and waits

Type `control-c` to exit the wait


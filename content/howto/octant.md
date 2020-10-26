---
title: "Install Octant on Kubernetes Cluster"
date: 2020-09-05T08:17:58-05:00
author: Jeff Fogarty
tags: ["home lab", "octant","kubernetes"]
draft: false
description: "Installing Octant on the cluster"
type: "howto"
weight: 6
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-25 </div><p>

> Providing access to modify your k8s cluster without proper controls is a security risk, duh.

The below is the tl;dr of [David Adams' article](https://medium.com/swlh/running-octant-as-a-container-on-vsphere-with-kubernetes-7845a34584fc)

Create a folder called `octant` and a subfolder called `octant-df`. 

```
mkdir -p ./octant/octant-df
```

In the `octant-df` folder, create the below [Dockerfile]() 

{{< gist jtfogarty 463f8977153da0e7ce1f184523881caf "Dockerfile">}}
> I'm also including the [Jenkins-x 3 plugin for Octant](https://github.com/jenkins-x/octant-jx/releases/)

The usage when building a docker image is `docker build [OPTIONS] PATH | URL | -` .  If I wanted to push to my Docker Hub repo I would use `docker build -t 007ba7/myImage .` In this case, it is the local repository server running at `10.10.100.14:5000`

```
cd ./octant/octant-df
sudo docker build -t 10.10.100.14:5000/octant:1.0 .
```

```
sudo docker push 10.10.100.14:5000/octant:1.0
```

We need a configmap so Octant can access the cluster.
```
kubectl create ns octant
kubectl create configmap octant-config --from-file ~/.kube/config -ns octant
```

Create the deployment yaml file as below;

{{< gist jtfogarty 463f8977153da0e7ce1f184523881caf "octant-deploy.yaml">}}


Run the below;
```
kubectl create -f octant-deploy.yaml -n octant
```

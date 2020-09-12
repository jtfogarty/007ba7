---
title: "HA Kubernetes"
date: 2020-09-05T11:07:10+06:00
author: Jeff Fogarty
tags: ["highly available", "kubernetes"]
description: "Creating an HA k8s cluster in my home lab"
draft: false
type: "projects"
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-11 </div><p>

This project consists of creating an HA Kubernetes cluster. This HA Cluster will use the 'production' hardware detailed [here](../../../homelab/kubernetes#production-cluster)

To make etcd HA, the below items are needed;

- Virtual IP (pfSense)
- HAProxy Load Balancer (pfSense)

After Kubernetes is up and running, All services will need a load balancer.  MetalLB will be configured along with OpenBGPD (pfSense).

Network diagram coming soon.
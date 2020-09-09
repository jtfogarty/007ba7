---
title: "Configuring MetalLB with pfSense"
date: 2020-09-04T21:41:12-05:00
author: Jeff Fogarty
tags: ["metallb", "pfsense","kubernetes"]
draft: false
description: "MetalLB / pfSense"
type: "howto"
weight: 2
---

MetalLB is a load-balancer for bare metal Kubernetes.  This example will explain how to configure MetalLB, pfSense Virtual IP and the OpenBGPD package for pfSense.

#### Prereqs 
- [X] Bare metal Kubernetes cluster.  Thanks to Dan Manners' project [SimpleSK8S](https://github.com/danmanners/SimpleSK8s), this is becoming very easy.
- [X] [Install OpenBGPD in pfSence](https://pfsense-docs.readthedocs.io/en/latest/packages/openbgpd-package.html)


---
title: "Configure MetalLB / OpenBGPD with pfSense"
date: 2020-09-04T21:41:12-05:00
author: Jeff Fogarty
tags: ["metallb", "pfsense","kubernetes","openbgpd"]
draft: false
description: "MetalLB / OpenBGPD in pfSense"
type: "howto"
weight: 2
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-23 </div><p>

MetalLB is a load-balancer for bare metal Kubernetes.  This example explains how to configure MetalLB, pfSense Virtual IP and the OpenBGPD package for pfSense.

#### Prereqs 
- [X] Bare metal Kubernetes cluster.  Thanks to Dan Manners' project [SimpleSK8S](https://github.com/danmanners/SimpleSK8s), this is becoming very easy.
- [X] [Install OpenBGPD in pfSence](https://pfsense-docs.readthedocs.io/en/latest/packages/openbgpd-package.html)

##### Create Virtual IPs in pfSense


> I need to collect my thoughts on this.  Give me a minute
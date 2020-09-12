---
title: "Configuring MetalLB/OpenBGPD with pfSense"
date: 2020-09-04T21:41:12-05:00
author: Jeff Fogarty
tags: ["metallb", "pfsense","kubernetes","openbgpd"]
draft: false
description: "MetalLB / OpenBGPD in pfSense"
type: "howto"
weight: 2
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-04 </div><p>

MetalLB is a load-balancer for bare metal Kubernetes.  This example will explain how to configure MetalLB, pfSense Virtual IP and the OpenBGPD package for pfSense.

#### Prereqs 
- [X] Bare metal Kubernetes cluster.  Thanks to Dan Manners' project [SimpleSK8S](https://github.com/danmanners/SimpleSK8s), this is becoming very easy.
- [X] [Install OpenBGPD in pfSence](https://pfsense-docs.readthedocs.io/en/latest/packages/openbgpd-package.html)

##### Create Virtual IPs in pfSense


<div class="shortcode-iframe-wrapper">
  <iframe class="shortcode-iframe" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vTL3OF0J5wKDIPNu1kGaKrQ_buqKERxY9DwgK7btuG0iLwfie4GW6Cly4KUcfciCLzRZkgO4ykkrf-X/pubhtml?gid=0&amp;single=true&amp;widget=true&amp;headers=false"></iframe>
</div>
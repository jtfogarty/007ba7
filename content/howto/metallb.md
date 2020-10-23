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
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-23 </div><p>

MetalLB is a load-balancer for bare metal Kubernetes.  This example explains how to configure MetalLB, OpenBGPD package within pfSense.

#### Prereqs 
- [X] Bare metal Kubernetes cluster.  Thanks to Dan Manners' project [SimpleSK8S](https://github.com/danmanners/SimpleSK8s), this is becoming very easy.
- [X] [Install OpenBGPD in pfSence](https://pfsense-docs.readthedocs.io/en/latest/packages/openbgpd-package.html)

##### OpenBGPD

I'm setting up 3 Kubernetes clusters. There will be services within each cluster that needs to be accessible from the internet.  

On the Settings tab in pfSense for the OpenBGPD service set the following;

- [X] Autonomous System (AS) Number = 64512
- [X] Holdtiem = leave blank
- [X] fib-update = yes
- [X] Listen on IP = 10.10.100.2
- [X] Router = 10.10.100.2
- [X] CARP Status UP = none
- [X] Networks = 10.10.100.0/22

The Listen on IP and Router are set to the VIP configured under Firewall | Virtual IPs
The network is the VLAN these clusters are on.  

> Further research:  Can I move one of these clusters to another VLAN?

###### - Groups

![image](../../img/lab/openbgpd/groups.png)

There should be one group, in OpenBGPD, for each Kubernetes cluster.

###### - Neighbors

![image](../../img/lab/openbgpd/neighbors.png)

> Only worker nodes should be listed

Each worker node, within each cluster, should be listed as above.

Each Kubernetes cluster will have MetalLB installed.  MetalLB requires a `configmap` For the `jx` cluster, this configmap is defined as below.

{{< gist jtfogarty 792cfa11d81378105d1420f06c4d7cb6 "metal-LB.yaml">}}

This details are mapped as below;

peers:
  - peer-address = Listen on IP
  - peer-asn = Autonomous System (AS) Number
  - my-asn = Remote AS (defined for the group)

address-pools:
  - name: default (can be almost anything)
  - protocal: bgp
  - addresses:
    - 10.10.100.50 - 10.10.100.100 


For the 3 Kubernetes clusters, the address pools are as follows;

| Cluster | Address Pool |
| --- | ----------- |
| jx | 10.10.100.50 - 10.10.100.100  |
| dev | 10.10.101.50 - 10.10.101.100  |
| prd | 10.10.102.50 - 10.10.102.100  |

When a `service` is created in Kubernetes, MetalLB will use the corresponding address pool to issue an external IP for each service created starting with 10.10.10x.50 and incrementing for each service.  An HAProxy backend needs to be created for each external IP issued.  It would be nice to automate the backend creation but that would take some doing.  
Looking at the `routes` within pfSense, you can see what OpenBPGD is ding.

![image](../../img/lab/openbgpd/routes.png)

Each cluster has 2 services defined and OpenBGPD has created routes between the address pool and the pyshical nodes in this group.

> Test if the 10.10.100.11 nodes goes down, does this route dynamically change?
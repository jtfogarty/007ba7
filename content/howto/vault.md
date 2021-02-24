---
title: "Install Vault on Kubernetes Cluster"
date: 2020-09-16T11:11:11+06:00
author: Jeff Fogarty
tags: ["home lab", "vault","kubernetes"]
draft: false
description: "Vault in a Home Lab"
type: "howto"
weight: 5
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2021-02-10 </div><p>


#### Outline
1. Create Certs via cfssl
2. Pull Vault helm chart
3. Configure Vault values file
4. Run helm install
5. Initialize
6. Unseal
7. Test adding secret from pod

##### Certs for a user
The below seems to work but I thought we needed to use the existing Kubernetes ca.cert file to sign the newly created user certs/keys.  

<script src="https://gist.github.com/jtfogarty/854a8fbdd3ca37b443a13ff3f9e1c328.js"></script>

systemctl restart iscsid open-iscsi


> Installing Harbor (container image registry) with Project Contour and Cert-Manager.  
> [YouTube](https://www.youtube.com/watch?v=SXSqrgYKO4s)
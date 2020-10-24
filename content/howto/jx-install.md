---
title: "Install Jenkins-x 3 On-Prem"
date: 2020-09-05T11:11:11-11:11
author: Jeff Fogarty
tags: ["kubernetes","install","jenkins-x 3"]
draft: false
description: "Installing Jenkins-x 3 in home lab"
type: "howto"
weight: 8
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-24 </div><p>

The prerequisites to installing Jenkins-x 3 in an On-Prem (HomeLab) environement are below.

1. [k8s and networking](../k8s-install)
2. [MetalLB](../metallb)
3. [Default Storage Class](../nfs-storage)
4. [Octant](../octant)

After the above are functioning, Jenkins-x 3 can be installed.  Below is the TL:DR for installing;

{{< gist jtfogarty f4bfdf115c745cf1ee515c397dd7ca37 "tldr.sh">}}

Lines 1 & 2 are to get the jx binary.  You should probably check to see what the latest version is.<br>
Line 3 is a command to upgrade the jx binary, if needed.<br>
Line 4 upgrades the plugins, duh<br>
Line 5 has a bit of background.
> Jenkins-x 3 will be installed from a generated Jenkins-x 3(jx3) repo in your own GitHub account.  The [Getting Started](https://jenkins-x.io/docs/v3/getting-started/on-premise/#getting-started) guide has a handy button to generate the repro from a template but before I did that, I logged out of my personal GitHub account and created a [new one](https://github.com/jtf-ops) for testing.  To install jx3, a personal access token is required. This handy link [Link Needed](https://jenkins-x.io)
will create the token with the needed permissions.   
After the repository is generated, copy the ssh clone command and clone this repo to your master server. `cd` into that directory

Line 7 is to edit the `jx-requirements.yml` file, adding the domain information for the webhook.
> I've enabled wildcard subdomain on `jx.docure.ai` and have a wildcard certificate.  I only have `https` (i.e port 443) available through pfSense so HAProxy is offloading the `ssl` certificate.  Inorder to make this work, I have configured the `jx-requirements.yml` file as below.
```
ingress:
  domain: jx.docure.ai
  externalDNS: false
  namespaceSubDomain: -jx.
  tls:
    email: ""
    enabled: false
    production: false
```
> This will allow `hook-jx.jx.docure.ai` to find it's destination.
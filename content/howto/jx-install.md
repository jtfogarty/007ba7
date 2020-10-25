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
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-25 </div><p>

##### PreReq

The prerequisites to installing Jenkins-x 3 in an On-Prem (HomeLab) environment are below.

1. [k8s and networking](../k8s-install)
2. [MetalLB](../metallb)
3. [Default Storage Class](../nfs-storage)
4. [Octant](../octant)

After the above are functioning, Jenkins-x 3 can be installed.  Below is the TL:DR for installing;

{{< gist jtfogarty f4bfdf115c745cf1ee515c397dd7ca37 "tldr.sh">}}
<br>
##### Line by line

Lines 1 & 2 are to get the jx binary. <br>
Line 3 is a command to upgrade the jx binary, if needed.<br>
Line 4 upgrades the plugins, duh<br>
Line 5 needs a bit of background.
> Jenkins-x 3 will be installed from a generated Jenkins-x 3(jx3) repo in your own GitHub account.  The [Getting Started](https://jenkins-x.io/docs/v3/getting-started/on-premise/#getting-started) guide has a handy button to generate the repro from a template but before I did that, I logged out of my personal GitHub account and created a [new one](https://github.com/jtf-ops) for testing.  To install jx3, a personal access token is required. This handy link [Link Needed](https://jenkins-x.io)
will create the token with the needed permissions.   
After the repository is generated, copy the ssh clone command and clone this repo to your master server. `cd` into that directory

Line 7 & 8 is to edit the `jx-requirements.yml` file, adding the domain information for the webhook.
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
This will allow `hook-jx.jx.docure.ai` to find it's destination.

> I tested setting `tls: enabled: true` but this does not support `ssl offloading` out of the box so I leave it off.  The result is that the `webhook` fails the first time it fires.  Simply changing the `webhook` to `https` and selecting `redelivery` fixes the issue;

![image](../../img/lab/jx/webhook.png)

Lines 9 - 14 are [steps](https://jenkins-x.io/docs/v3/guides/health/) needed to install [KuberHealthy](https://github.com/Comcast/kuberhealthy).  Since this is a new install, it is not clear to me if lines 9 & 10 are needed but lines 10 - 14 are needed.  The results of these commands (10 - 14) are that the `helmfile.yaml` is updated in the `repositories:` and `releases:` sections as seen below respectively. 

```
- name: kuberhealthy
  url: https://comcast.github.io/kuberhealthy/helm-repos
```

```
- chart: kuberhealthy/kuberhealthy
- chart: jx3/jx-kh-check
- chart: jx3/jx-kh-check
  name: health-checks-jx
- chart: jx3/jx-kh-check
 name: health-checks-install
```

Line 15 is important because it pushes these changes to the jtf-ops git repo.  
Line 16 executes the process to install `jx` .  This process clones jtf-ops into a container in the 'jx boot' or 'jx install` pods and installs base off the clone.  Pushing change into your git repo is required in order to see the expected results. 
> When  `jx admin operator` is executed, you need to enter the user name, in this case `jtf-ops` and then the generated token. I'm not sure this is needed each time or only the first time.

After this process finishes successfully, I changed the `webhook` as detailed above.  

The `jx admin operator` made changes to the cloned `jtf-ops` repository and pushed back to GitHub. To get all of these changes on my local clone, I executed `git pull`

Executing `jx health get status --all-namespaces --watch` will eventually display the below.

![image](../../img/lab/jx/kuberhealthy.png)
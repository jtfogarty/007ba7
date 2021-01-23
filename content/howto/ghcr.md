---
title: "Configure k8s to use GitHub Container Registry"
date: 2021-01-22T11:11:11+06:00
author: Jeff Fogarty
tags: ["home lab", "github","kubernetes"]
draft: false
description: "Using GitHub Container Registry"
type: "howto"
weight: 9
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2021-01-22 </div><p>


#### TL;DR
- [X] [Create Token](https://github.com/settings/tokens)
- [X] Encode the User Name and Token
- [X] Create .dockerconfigjson file
- [X] Execute Imperative kubectl command
- [X] Create Pod that uses Secret
- [X] Modify Service Account to use Secret

To encode the user name and token, execute the below;
```
echo -n "jtfogarty:VGhpcyBJcyBOb3QgYSBSZWFsIEdpdEh1YiBUb2tlbg==" | base64
```
which yields
> anRmb2dhcnR5OlZHaHBjeUJKY3lCT2IzUWdZU0JTWldGc0lFZHBkRWgxWWlCVWIydGxiZz09


Build the .dockerconfigjson file as below;

```
{
    "auths":
    {
        "ghcr.io":
            {
                "auth":"anRmb2dhcnR5OlZHaHBjeUJKY3lCT2IzUWdZU0JTWldGc0lFZHBkRWgxWWlCVWIydGxiZz09"
            }
    }
}
```

Create a docker registry secret using the below command
```
kubectl create secret docker-registry ghcr-config-jtf --from-file=.dockerconfigjson
```

Create a pod manifest to pull from ghcr.io

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-pod
  name: my-pod
spec:
  containers:
  - image: gchr.io/jtfogarty/my-image:1.1
    name: my-pod
  imagePullSecrets:
  - name: ghcr-config-jtf
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

An alternative approach is to modify the default service account for the namespace to use the newly created secret.

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "ghcr-config-jtf"}]}'

When a new pod is created, the `spec.imagePullSecrets` field is set automatically.  
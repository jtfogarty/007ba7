---
title: "CKA Prep"
date: 2020-10-10T11:11:11+11:11
author: Jeff Fogarty
tags: ["homelab","home","lab","Certified Kubernetes Administrator","Kubernetes Storage"]
description: "Preparation for Certified Kubernetes Administrator"
draft: false
type: "blog"
weight: 2
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-10 </div><p>

#### Understanding Kubernetes Storage

During my preparation for the Certified Kubernetes Administrator (CKA) exam, I went about creating the below PV and PVC followed by a pod to use this storage.  

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "PV.yaml">}}

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "PVC.yaml">}}

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "pod.yaml">}}

My expectation was to find a PVC connected to a PV but when I executed `kubectl get pv,pvc` I found the below;

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "kubectl get pv,pvc">}}

The PVC did not use the newly create PV `lab6-pv-volume` but created a new PV using the default storage class `managed-nfs-storage`. 
Noticing that I created the PV with 2Gi but defined the PVC as 1Gi, I thought I would try a simple solution of creating another PVC with 2Gi but this did not change anything as can be seen below;

> This default storage class was created from this [HowTo](../../howto/nfs-storage)

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "kubectl get pv,pvc-a">}}


So the question is why?  Why is Kubernetes choosing to create a new PV using the default storage class rather than the `lab6-pv-volume`.  There is nothing explicit in the PVC that tells the API to use `lab6-pv-volume`.  The instructor did mention that Kubernetes sees that both the PV and PVC have an `accessModes` of `ReadWriteOnce` and that is how they get connected.  I need to remove `default` from `managed-nfs-storage` to test this.

> To make this change, execute the below; <br>
> `kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'`

Sure enough, after making the above change and creating another PVC, it is using the manually created PV.

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "kubectl get pv,pvc-b">}}

The next question that comes to mind is. How can we create a PVC, with a default storage class defined, and have it use a manually created PV?  Is there a way to explicitly tell the API to use a PV when creating a PVC?

After creating another PV and PVC, defined below;

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "lab6-pv-a.yaml">}}

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "lab6-pvc-a.yaml">}}

PVC lab6-pv-claim-a is stuck in pending. 

{{< gist jtfogarty 1725f639b806c3efb04be6ec18fc99c5 "kubectl get pv,pvc-c">}}

 I'm seeing the below warning when I do `kubectl describe pvc lab6-pv-claim-a`;

```
Cannot bind to requested volume "lab6-pv-volume-a": storageClassName does not match
```

I need to do more research
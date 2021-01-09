---
title: "CKAD Study Guide"
date: 2020-10-10T11:11:11+11:11
author: Jeff Fogarty
tags: ["homelab","home","lab","Certified Kubernetes Application Developer","Kubernetes Storage","CKAD"]
description: "Study Guide for Certified Kubernetes Application Developer"
draft: false
type: "blog"
weight: 2
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2021-01-09 </div><p>

The below details my approach when studying for the CKAD.  

### On-line Training

Below are the sites I used to prepare.

##### Udemy
[Kubernetes Certified Application Developer (CKAD) with Tests](https://www.udemy.com/course/certified-kubernetes-application-developer/)
 
##### O'Reilly Learning Site
[Certified Kubernetes Application Developer (CKAD)](https://learning.oreilly.com/videos/certified-kubernetes-application/9780136677628/)

##### Free Practice Exam by Liptan Biswas
[CKAD Practice Questions](https://dev.to/liptanbiswas/ckad-practice-questions-4mpn)

<br>
I did not use A Cloud Guru for the CKAD mainly because they are out of date.  The Kubernetes version is 1.12. <br> 
Reviewing the Labs in A Cloud Guru and understanding the solution using the kubectl imperative method for the current test version is well worth the effort.

##### A Cloud Guru
[Certified Kubernetes Application Developer (CKAD)](https://learn.acloud.guru/course/d068441f-75b4-4fe8-a7a6-df9153f24a35/dashboard)

### Practice servers
- Udemy uses KataKoda
- Liptan Biswas' Practice Exam uses KataKoda

The nodes for KataKoda have tmux and bash_completion already installed.  I found it helpful using both tmux and bash_completion when taking the practice exams but I did not use them during the real exam.  I was not comfortable running the below prior to the exam.

```
apt update
apt install tmux bash_completion
``` 
<br>

###### tmux
It is really nice to have a split terminal with `kubectl explain cronjob.spec --recursive |less` up are the right pane and the yaml in vim on the left.  
> One annoyance with using tmux in KataKoda is that copying text does not work within the shell window.  So if I wanted to copy `concurrencyPolicy` from the right pane to the left, I had to type it out. The right click copy menu is not available within tmux.

![image](../../img/sg-01.png?width=500px)

<br>

###### bash_completion
Bash Completion is very helpful when learning especially with all of the --options.  Below is the output when typing `k create cronjob --` and then hit the tab key twice.

> Use this [reference](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-bash-completion) to configure bash_completion 

![image](../../img/sg-02.png?width=500px)

<br>

### Practice, Practice, Practice

The way I studied is to take the lightning labs and practice tests over and over and over again.  The goal is to NOT memorize the questions or answers but to get 'muscle memory' on creating yaml files using either the imperative method or copying them from [Kubernetes Documentation](https://kubernetes.io/docs/home/).  

<br>

### Tips

#### One File with multiple blocks
Several of the practice question had the need to create a PV, a PV and PVC or a PV, PVC and a Pod.  It takes seconds to copy these yaml blocks.  This [link](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolume) has all three yamls.  Simply copy each and paste into a single yaml file with `---` separating each block as below; 

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage
```

Then simply change the names, paths or image as the question states.

#### Multiple container pods
When creating a pod with multiple containers, one method I found helpful was to use the imperative method twice, targeting the same file.

Say we are asked to create a pod with 2 image using the below specifications

- Pod Name = my-2-containers
- Image 1 Name = myBb
- Image 1 image = busybox
- Image 1 command = sleep 3600
- Image 2 Name = myAl
- Image 2 image = alpine
- Image 2 command = sleep 5600

Run the below;

```
kubectl run my-2-containers --image=busybox --dry-run=client -o yaml --command -- sleep 3600 > my-2-pods.yaml

kubectl run myAl --image=alpine --dry-run=client -o yaml --command -- sleep 5600 >> my-2-pods.yaml
```

Notice the `>>` in the second command.  This appends the output of the dry run to the file.  

The output is as below;
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-2-containers
  name: my-2-containers
spec:
  containers:
  - command:
    - sleep
    - "3600"
    image: busybox
    name: my-2-containers
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: myAl
  name: myAl
spec:
  containers:
  - command:
    - sleep
    - "5600"
    image: alpine
    name: myAl
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

Next, change the name of the first container and delete the appropriate lines as below;

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-2-containers
  name: my-2-containers
spec:
  containers:
  - command:
    - sleep
    - "3600"
    image: busybox
    name: myBb
  - command:
    - sleep
    - "5600"
    image: alpine
    name: myAl
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

#### Commands

Compare the below;
```
kubectl create job hello --image=busybox --dry-run=client -o yaml -- sleep 3600
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: hello
spec:
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - command:
        - sleep
        - "3600"
        image: busybox
        name: hello
        resources: {}
      restartPolicy: Never
status: {}
```

```
kubectl run my-2-containers --image=busybox --dry-run=client -o yaml -- sleep 3600
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-2-containers
  name: my-2-containers
spec:
  containers:
  - args:
    - sleep
    - "3600"
    image: busybox
    name: my-2-containers
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
Adding the `--command` option changes the output
```
kubectl run my-2-containers --image=busybox --dry-run=client -o yaml --command -- sleep 3600
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-2-containers
  name: my-2-containers
spec:
  containers:
  - command:
    - sleep
    - "3600"
    image: busybox
    name: my-2-containers
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

The execution between
```
- command:
    - sleep
    - "3600"
```
and 
```
- args:
    - sleep
    - "3600"
```

Appears identical but I would lean for insuring `command:` syntax.
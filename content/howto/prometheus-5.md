---
title: "Install Prometheus and Kuberhealthy"
date: 2020-09-16T11:11:11+06:00
author: Jeff Fogarty
tags: ["home lab", "prometheus","kubernetes","kuberhealthy"]
draft: false
description: "Jenkins-x in a Home Lab"
type: "howto"
weight: 5
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-21</div><p>

###### Add the repos for each
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add kuberhealthy https://comcast.github.io/kuberhealthy/helm-repos
helm repo update
```
<br>

###### Install Prometheus
```
kubectl create ns prometheus
kubectl config set-context --current --namespace=prometheus

helm install prome-opr prometheus-community/kube-prometheus-stack
```
<br>

###### Install Kuberhealthy
```
kubectl create ns kuberhealthy
kubectl config set-context --current --namespace=kuberhealthy

helm install kuberhealthy kuberhealthy/kuberhealthy --set prometheus.enabled=true,prometheus.enableAlerting=true,prometheus.serviceMonitor=true
```
<br>

###### Change the Grafana service to LoadBalancer
```
kubectl edit svc prome-opr-grafana
```
The default user name and password is `admin/prom-operator`
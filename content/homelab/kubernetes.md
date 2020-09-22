---
title: "Kubernetes Clusters"
date: 2020-07-24T11:07:10+06:00
author: Jeff Fogarty
tags: ["home", "lab","kubernetes"]
description: "Kubernetes Cluster Specifications"
draft: false
type: "post"
weight: 2
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-12 </div><p>

### Development Cluster

The master node is a [Gigabyte GB-BSi5-6200](https://www.amazon.com/gp/product/B0196LP1LG/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)<br/>
Two of the worker nodes are [Gigabyte GB-BLCE-4105](https://www.amazon.com/gp/product/B07DMM7Z7N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)<br/>
The third worker node is a former gaming rig with the below specs;

  - AMD Ryzen 7 3800X 8-Core Processor with 16 cores
  - 32GB of RAM
  - 1TB nvme for the OS
  - 2TB nvme for whatever
  - NVIDIA RTX 2060 GPU

### Production Cluster

The 2 master nodes are [Gigabyte GB-BLCE-4105](https://www.amazon.com/gp/product/B07DMM7Z7N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)<br/>
The 3 worker are NUC10i7FNH with 10 Core i7-10710U, 16GB DDR4 Mem, 512GB SATA M.2 SSD, 2TB 2.5in HDD
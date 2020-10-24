---
title: "Overview"
date: 2020-07-24T11:07:10+06:00
author: Jeff Fogarty
tags: ["home", "lab","overview"]
description: "Home Lab Overview"
draft: false
type: "post"
weight: 1
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-10-24 </div><p>

![image](../../img/lab/gallery/IMG_5847.jpg?width=500px)

Here is the current view.  

Starting with the [wall rack](https://www.amazon.com/gp/product/B01M1OCOC7/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1), top to bottom.

- [Ubiquiti US-16-150W PoE](https://www.amazon.com/gp/product/B01E46ATQ0/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [TRENDnet 24-Port Cat6A Shielded 1U Patch Panel](https://www.amazon.com/gp/product/B07D5RQGKF/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [XG-7100 1U Gateway with pfSense](https://store.netgate.com/XG-7100.aspx)
- [1U Planking Panel](https://www.amazon.com/gp/product/B003AVPUWY/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [Vented 1U Rack Shelf](https://www.amazon.com/gp/product/B01C9KYUG8/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
  - On this shelf is an AT&T modem
- [1U Planking Panel](https://www.amazon.com/gp/product/B003AVPUWY/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [Vented 1U Rack Shelf](https://www.amazon.com/gp/product/B01C9KYUG8/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
  - [2 Gigabyte GB-BLCE-4105](https://www.amazon.com/gp/product/B07DMM7Z7N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
  - [1 Gigabyte GB-BSi5-6200](https://www.amazon.com/gp/product/B0196LP1LG/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [Cooling Plate](https://www.amazon.com/gp/product/B00ZQPDB7I/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [UPS System](https://www.amazon.com/gp/product/B000XJLLKG/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
- [Power Strip](https://www.amazon.com/dp/B00BQO5S0G/?coliid=I2AFZU0EWBLSW4&colid=1WAP5034L6ZQL&psc=1&ref_=lv_ov_lig_dp_it)

I've created an Amazon [list](https://www.amazon.com/hz/wishlist/ls/1WAP5034L6ZQL?ref_=wl_share) for most of these items

On the left of the table is a [SimplyNUC server shelf](https://simplynuc.com/3u-nuc-server-shelf/) with [3 - NUC10i7FNH](https://simplynuc.com/10i7fnh-full/), Power Supply and an unmanaged switch.
I also have [2 Gigabyte GB-BLCE-4105](https://www.amazon.com/gp/product/B07DMM7Z7N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1) 
The Power Supply feeds the 3 NUCs and the 2 Gigabytes.

In between the SimplyNUC shelf an the monitor is a [QNAP TS-473-4G-US 4-Bay NAS](https://www.amazon.com/gp/product/B07BMYKYKJ/ref=ppx_yo_dt_b_asin_title_o07_s00?ie=UTF8&psc=1)

I also have 'gaming' machine, not in this picture.  The specs are below;
- AMD Ryzen 7 3800X 8-Core Processor with 16 cores
- 32GB of RAM
- 1TB nvme for the OS
- 2TB nvme for whatever
- NVIDIA RTX 2060 GPU

There is stack of Raspberry Pi's sitting on top of the NAS.  I was hoping to install [POWERPANEL® BUSINESS 4](https://www.cyberpowersystems.com/products/software/power-panel-business/) on one of the Pi's but this OS is not supported. 
I'll have to buy one more [Gigabyte GB-BLCE-4105](https://www.amazon.com/gp/product/B07DMM7Z7N/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)

The keyboad is a [Das Keyboard 4](https://www.amazon.com/stores/Das+Keyboard/page/DF548711-D8BE-4659-83AE-A5FAFF411E10?ref_=ast_bln)

#### Environments

###### Jenkins-x 3 Testing<br>
1 Master - GB-BSi5-6200<br>
2 Workers - GB-BLCE-4105<br>

###### Development<br>
1 Master - GB-BLCE-4105<br>
2 Workers - 1 NUC10i7FNH and a former gamming machine, defined above<br>

###### Production<br>
1 Master - GB-BLCE-4105<br>
3 Workers - NUC10i7FNH<br>
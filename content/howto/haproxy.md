---
title: "Configuring HAProxy on pfSense"
date: 2020-07-24T11:07:10+06:00
author: Jeff Fogarty
description: "this is howto meta description"
draft: false
type: "howto"
---

This example will show you how to access an application on the internet via https using HAProxy in pfSense.  

Prereqs 
- [X] [Install HAProxy in pfSence](https://docs.netgate.com/pfsense/en/latest/book/packages/managing-packages.html)
- [X] [Create Subdomain](https://www.namecheap.com/support/knowledgebase/article.aspx/9776/2237/how-to-create-a-subdomain-for-my-domain)
- [X] [Setup Let's Encrypt](https://laskowski-tech.com/2017/12/04/acme-plugin-on-pfsense-add-lets-encrypt-cert-to-your-firewall/#:~:text=So%20here's%20a%20little%20guide,select%20the%20Account%20keys%20tab)
- [X] [Create or add wildcard Subdomain to Let's Encrypt key](https://www.danielcolomb.com/2019/08/29/creating-wildcard-certificates-on-pfsense-with-lets-encrypt/)

Now we can configure HAProxy.

In pfSense go to Services | HAProxy. The HAProxy page will display.  The first thing to do is to set the Max SSL Diffie-Hellman size to 2048 under the Tuning section.  
Next select Backend and select Add. In this example we will use the subdomain of blog.mydomain.com so name the backend blog.mydomain.com



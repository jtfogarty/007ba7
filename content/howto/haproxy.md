---
title: "Configuring HAProxy on pfSense"
date: 2020-07-24T11:07:10+06:00
author: Jeff Fogarty
description: "this is howto meta description"
draft: false
type: "howto"
---

This example will show you how to access an application on the internet via https using HAProxy in pfSense.  The goal in this example is to be able to access an internally hosted site via `HTTPS` while the internal traffic is `HTTP`

#### Prereqs 
- [X] [Install HAProxy in pfSence](https://docs.netgate.com/pfsense/en/latest/book/packages/managing-packages.html)
- [X] [Create Subdomain](https://www.namecheap.com/support/knowledgebase/article.aspx/9776/2237/how-to-create-a-subdomain-for-my-domain)
- [X] [Setup Let's Encrypt](https://laskowski-tech.com/2017/12/04/acme-plugin-on-pfsense-add-lets-encrypt-cert-to-your-firewall/#:~:text=So%20here's%20a%20little%20guide,select%20the%20Account%20keys%20tab)
- [X] [Create wildcard Subdomain to Let's Encrypt key](https://www.danielcolomb.com/2019/08/29/creating-wildcard-certificates-on-pfsense-with-lets-encrypt/)

Now we can configure HAProxy.

#### Basic Configuration
In pfSense go to Services | HAProxy. The HAProxy page will display.  The first thing to do is to set the Max SSL Diffie-Hellman size to 2048 under the Tuning section.  

#### Backend
Now select Backend and select Add. In this example we are setting up the frontend and backend HAProxy for a blog running at blog.mydomain.com.  As Mr. Karlton states below, coming up with names is hard.  What make sense in one context does not in another.  Let's just name this backen `blog` and see how this works out.


>There are only two hard things in Computer Science: cache invalidation and naming things.<p>
>-- Phil Karlton

![image](../../img/lab/haproxy/backend-a.png)

Clicking on the little green arrow below `mode` allows the backend server information to be added.
![image](../../img/lab/haproxy/backend-b.png)


Again, we have to come up with a name.  This website will run in Kubernetes so I will prefix this backend with k8s followed by the [namespace](https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/) and then followed by the [service name](https://kubernetes.io/docs/concepts/services-networking/service/).  

Setting the healthcheck to basic or none will insure the backend will work for the intial test.  We will explore other healthcheck methods in later posts.
![image](../../img/lab/haproxy/healthcheck.png)

#### Frontend

Select Add to create a new frontend.  We have yet another name to think up.  We will use `mydomain.com` for this one.  
![image](../../img/lab/haproxy/frontend-a.png)

Give it a description and set it to `active`.  The external address in this case is just set to the WAN address. The actual address can be found in Interfaces | WAN `IPv4 Address`  The port shoudl be set to 443 since we are accessing via `HTTPS' and select HTTP Offloading`. The `type` setting below is left at the `http/https(offloading)` default.
  
![image](../../img/lab/haproxy/frontend-b.png)

The combination of an Access Control List and an Action is how HAProxy determines where to send the inbound request.  We define an ACL, in this example when the inbound host matches `blob.mydomain.com` use the blog backend.  
![image](../../img/lab/haproxy/frontend-c.png)

Below is how I configured the certificate section.  
![image](../../img/lab/haproxy/cert-a.png)
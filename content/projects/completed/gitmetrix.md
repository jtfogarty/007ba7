---
title: "gitmetrix"
date: 2020-09-05T11:07:10+06:00
author: Jeff Fogarty
tags: ["home", "lab"]
description: "Svelte App for reporting data from GitHub"
draft: false
type: "projects"
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2020-09-04 </div><p>

[GitMetrix](https://gitmetrix.007ba7.us) is a Svelte application that pulls data from GitHub for the [Kubeflow](https://kubeflow.org) project.  It allows reporting on Issue Age, Issue Backlog, Triage Count and Owners Files.  All but the Owners files uses GraphQL interface to GitHub.  The Owners Files uses the http API
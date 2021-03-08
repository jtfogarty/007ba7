---
title: "Install Vault on Kubernetes Cluster"
date: 2020-09-16T11:11:11+06:00
author: Jeff Fogarty
tags: ["home lab", "vault","kubernetes"]
draft: false
description: "Vault in a Home Lab"
type: "howto"
weight: 11
---
<div style="font-size: 12px; text-align: right !important"; >Updated 2021-03-08 </div><p>

The goal of this example is to detail the setup of Vault/Vault Agent Injector via Helm using TLS.

The below image details the install process.  
![image](../../img/lab/vault/flow.png)

> Modifying the values chart is not shown in the above process flow
#### Helm Chart
To get the latest Vault Helm chart, execute the below;
```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm pull hashicorp/vault
tar -xzvf vault-0.9.1.tgz
cd vault
```

> In the below example and in my repo, the helm chart for vault is in the `vault-helm` directory <br>
> The directory structure is <br>
>   vault-install  <br>
    ├── install.sh <br>
    ├── setup-v1-injector.sh <br>
    ├── setup-v1.sh <br>
    └── vault-helm
#### github repo
The github repo for this example is [here](https://github.com/jtfogarty/k8s-journal/blob/master/vault-install)

##### values.yaml

Below lists the changes;
```
global.tlsDisable: false                                            # line 12

injector.certs.secretName: vault-agent-injector-tls                 # line 96
injector.certs.caBundle: "CA-BUNDLE-REPLACE-ME"                     # line 101
injector.certs.certName: vault-injector.crt                         # line 106
injector.certs.keyName: vault-injector.key                          # line 107
injector.resources.requests.memory: 256Mi                           # line 112
injector.resources.requests.cpu: 250m                               # line 113
injector.resources.limits.memory: 256Mi                             # line 115
injector.resources.limits.cpu: 250m                                 # line 116

server.resources.requests.memory: 256Mi                             # line 183
server.resources.requests.cpu: 250m                                 # line 184
server.resources.limits.memory: 256Mi                               # line 186
server.resources.limits.cpu: 250m                                   # line 187
server.extraEnvironmentVars:                                        # line 300 remove {}
server.VAULT_CACERT: /vault/userconfig/vault-server-tls/vault.ca    # line 304
server.extraVolumes:                                                # line 316 remove []
server.extraVolumes
    - type: secret                                                  # line 317
      name: vault-server-tls                                        # line 318

server.auditStorage.enabled: true                                   # line 436
server.standalone.enabled: true                                     # line 466
server.standalone.config: |                                         # line 478 - 486
      ui = true

      listener "tcp" {
        tls_disable = 0
        address = "0.0.0.0:8200"
        cluster_address = "[::]:8201"
        tls_cert_file = "/vault/userconfig/vault-server-tls/vault.crt"
        tls_key_file  = "/vault/userconfig/vault-server-tls/vault.key"
        tls_client_ca_file = "/vault/userconfig/vault-server-tls/vault.ca"

ui.enabled: true                                                    # line 616
```
By adding CA-BUNDLE-REPLACE-ME to line 101, the [install.sh](https://github.com/jtfogarty/k8s-journal/blob/master/vault-install/install.sh) script can replace this string with the `vault-injector.ca` string.

The `server.standalone.config` section was unclear from the below references.  The `global.tlsDisable` must be `false` but also `tls_disable` must be equal to 0 or the client will not be able to communicate to the server.

##### Install Script
<script src="http://gist-it.appspot.com/https://github.com/jtfogarty/k8s-journal/blob/master/vault-install/install.sh"></script>

### References
[A Vault for all your Secrets (full TLS on kubernetes with kv v2)](https://blog.cogarius.com/index.php/2020/03/13/a-vault-for-all-your-secrets-full-tls-on-kubernetes-with-kv-v2/)<br>
[Introduction to HashiCorp Vault on Kubernetes for beginners](https://www.youtube.com/watch?v=L_o_CG_AGKA&list=PLHq1uqvAteVtq-NRX3yd1ziA_wJSBu3Oj)<br>
[Standalone TLS](https://www.vaultproject.io/docs/platform/k8s/helm/examples/standalone-tls)
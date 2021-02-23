---
author: "EricKwan"
categories: ["oVirt", "VMs"]
date: 2017-09-01T03:36:08Z
description: ""
draft: false
slug: "ovirt-guest-agent"
tags: ["oVirt", "VMs"]
title: "How to install the ovirt-guest-agent in Ubuntu"
---

![logo](/learning-journey/images/2017/09/ovirt-guestagent-001-700x210.png)

## Step 1

Please follow this [link](https://www.ovirt.org/documentation/how-to/guest-agent/install-the-guest-agent-in-ubuntu/) in order to install the ovirt-guest-agent in Ubuntu

## Step 2

Type the below commands to make sure the ovirt-guest-agent will autostart when VMs startup

```sh
systemctl enable ovirt-guest-agent
systemctl start ovirt-guest-agent
```

## Conclusion

You learn how to install the ovirt guest agent and obtain additional information about the VM.

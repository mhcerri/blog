---
date: 2015-08-04T08:57:42Z
tags:
- networkmanager
- linux
title: NetworkManager dispatchers
---

NetworkManager makes network configuration easy and simple, but it also provides some cool features to specific scenarios.

I use rygel in my small home server to stream videos to other devices in my local network. Currently this home server is connect to my network via wifi (I'm using a cheap android stick with linux as my home server and it doesn't have an ethernet interface) and eventually the wifi connection can drop. My major problem with that scenario is that after the wifi connection is reestablished rygel doesn't re-announce itself in the network.

And that's where NetworkManager dispatchers come to the rescue to workaround this problem. Dispatchers are executed when NetworkManager changes the state of any interface. They are placed in the directory `/etc/NetworkManager/dispatcher.d/`, and they receive interface's name and state (up or down) as arguments when executed.

So, I created the simple script bellow to restart rygel everytime that any interface is brought up:

`/etc/NetworkManager/dispatcher.d/99-rygel`

```sh
#!/bin/sh
SERVICE=rygel.service
case "$2" in
  up)
    systemctl is-active "$SERVICE" &&
    systemctl restart "$SERVICE"
    ;;
esac
```

_Note: I'm currently using Arch Linux networking scripts and MiniDLNA_

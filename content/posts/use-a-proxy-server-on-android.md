---
date: 2015-08-04T01:40:36Z
tags:
- android
- proxy
- connectbot
- firefox
title: Use a proxy server on Android
---

When I'm connected with my mobile phone to a network that I don't trust or has limited connection, I usually use my remote server as a web proxy to access the internet.

The setup steps are simple:

- Install `connectbot` from [F-Droid][fdroid].

- Configure an SSH connection to your host with a dynamic port forwarding (SOCKS) on the port 9999.

- Install `firefox` for Android.

- Open the URL `about:config` on Firefox and change the following configurations:

    - `network.proxy.socks`: `localhost`
    - `network.proxy.socks_port`: `9999`
    - `network.proxy.socks_remote_dns`: `true`
    - `network.proxy.type`: `1` (forces Firefox to use manual proxy)

[fdroid]:   https://f-droid.org/

---
date: 2015-10-23T00:36:06Z
tags:
- atom
- proxy
title: Configure a proxy for Atom
---

In order to install packages from the internet a proxy needs to be set up if Internet connection is not directly available.

- Edit the file `$HOME/.atom/.apmrc` and add the following lines:

```
; Proxy
https-proxy=http://your-proxy-host:your-proxy-port
http-proxy=http://your-proxy-host:your-proxy-port
strict-ssl=false
```

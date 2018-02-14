---
date: 2015-08-04T01:30:48Z
tags:
- vnc
- desktop
title: Sharing desktop via VNC
---

Install `tigervnc`.

Generate a password.

```console
$ vncpasswd ~/.vncpasswd
Password:
Verify:
Would you like to enter a view-only password (y/n)? n
```

Run `x0vncserver`.

```console
$ x0vncserver -passwordfile ~/.vncpasswd
```

Check if the firewall is not blocking connections to the port 5900 and try to access the current desktop using a VNC client from other machine.


---
title: Download all files listed in a page
date: 2017-09-21T15:10:56-03:00
tags:
- wget
- tricks
---

Example:

```
wget -A deb -m -E -nd -np -e robots=off 'http://kernel.ubuntu.com/~mhcerri/azure/lp1718740-kvm/'
```

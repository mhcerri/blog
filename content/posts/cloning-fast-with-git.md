---
title: Cloning fast with Git
date: 2017-02-15T12:49:17-02:00
tags:
- git
---

When a similar repository is already available locally on the machine, it's 
possible to use it to avoid to download the entire repository.

Example:

	git clone --progress --reference ./yakkety/ --dissociate git+ssh://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/zesty

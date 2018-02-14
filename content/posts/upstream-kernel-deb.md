---
title: Debian packaging generic kernels
date: 2017-03-13T10:09:44-03:00
tags:
- kernel
- deb
- ubuntu
---

Copy a your `.config` file to the kernel directory and run:

	make deb-pkg -j $(getconf _NPROCESSORS_ONLN) LOCALVERSION=-custom KDEB_PKGVERSION=$(make kernelversion)-1

> Set `CONFIG_DEBUG_INFO=n` if you want to avoid to build the debug symbol package.

Cross compiling
---------------

Install the target cross compile toolchain and add the following variable to
the make command:

	ARCH=<arch> CROSS_COMPILE=/usr/bin/<toolchain-arch>-linux-gnu-

- `<arch>` should match one directory in `./arch/`.
- `<toolchain-arch>` is the prefix of the cross compilation tools.

Example:

	ARCH=s390 CROSS_COMPILE=/usr/bin/s390x-linux-gnu-

> Note that `ARCH` used `s390` while `CROSS_COMPILE` used `s390x`.

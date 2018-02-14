---
title: Testing with autopkgtest
date: 2017-12-13T15:39:52-02:00
tags:
- ubuntu
- autopkgtest
- test
---

From `apt show autopkgtest`:

```
Package: autopkgtest
...
Description: automatic as-installed testing for Debian packages
 autopkgtest runs tests on binary packages.  The tests are run on the
 package as installed on a testbed system (which may be found via a
 virtualisation or containment system).  The tests are expected to be
 supplied in the corresponding Debian source package.
 .
 See adt-run(1) and /usr/share/doc/autopkgtest.
 Depending on which virtualization server you want to use, you need to
 install additional packages (schroot, lxc, lxd, or qemu-system)
 .
 For generating tests of well-known source packages such as Perl and Ruby
 libraries you should install the autodep8 package.
```

The file `/usr/share/doc/autopkgtest/README.running-tests.rst.gz` contains
useful information on how to run tests.

Additional documentation:

`/usr/share/doc/autopkgtest/README.click-tests.rst.gz`

`/usr/share/doc/autopkgtest/README.package-tests.rst.gz`

`/usr/share/doc/autopkgtest/README.virtualisation-server.rst.gz`

Simple (local) test
-------------------

1. Start with a source package. `apt source` is a good option:

	```
	mkdir systemd
	cd systemd
	apt source systemd
	cd systemd-229/
	```

2. Run the package tests:

	```
	sudo adt-run -d ./ --- null
	```

> The tests might modify the system. Although that's a very simple way to run
> the test, it's recommended to use a virtual machine for that.

Testing with QEMU
-----------------

Using QEMU allows tests to perform some operations that other backends do not
allow, such as reboots. Besides that the tests are executed in an overlay
image, preserving the original image for further tests.

1. Start with a source package (check previous section).

2. Create a base QEMU image to run the tests:

	```
	adt-buildvm-ubuntu-cloud -v
	```

	> Check `man adt-buildvm-ubuntu-cloud` for additional options.


	> Use `autopkgtest-buildvm-ubuntu-cloud` if `adt-buildvm-ubuntu-cloud`
	> is not available.

3. Customize your base image:

	```
	kvm -m 1024 -nographic -net user -net user -net nic,model=virtio ./adt-xenial-amd64-cloud.img
	```

	> The default username and password for the image is `ubuntu`/`ubuntu`.
	>
	> Use `Ctrl-a x` to exit or `Ctrl-a h` for help.

4. Run the tests in a virtual machine:

	```
	adt-run --unbuilt-tree  ./ --- qemu ./adt-xenial-amd64-cloud.img
	# Or with debug messages:
	adt-run -d --unbuilt-tree  ./ --- qemu -d ./adt-xenial-amd64-cloud.img
	```

	> Check `man adt-virt-qemu` to see what option you can pass to the QEMU
	> virtual server.

Useful links
------------

- [Tutorial: Functional Testing of Debian Packages](https://annex.debconf.org/debconf-share/debconf15/slides/173-tutorial-functional-testing-of-debian-packages.pdf)

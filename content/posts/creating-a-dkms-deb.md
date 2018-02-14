---
title: Creating a DKMS deb package
date: 2017-02-21T09:12:00-03:00
tags:
- ubuntu
- kernel
- deb
- dkms
---

All the steps to create a deb package with a DKMS module. It's assumes a native
deb package for simplicity.

Preparation
-----------

1. Install tools for deb packaging:

	apt install devscripts dh # TODO check it

2. Install DKMS:

	apt install dkms


Generate a base debian package
------------------------------

By default, `dkms mkdsc` uses the systems directories when creating and building
a DKMS package.

To override that, create a file pointing to your local directory:

	cat > framework.confg << EOF
	source_tree="$PWD/"
	dkms_tree="$PWD/dkms"
	EOF

Example:

	$ cat framework.conf
	source_tree="/home/mhcerri/workspace/linux/vmbus-rdma/"
	dkms_tree="/home/mhcerri/workspace/linux/vmbus-rdma/dkms"

And create the `dkms` directory:

	mkdir ./dkms

Create a directory following the pattern: `<package name>-<version>`.

Example:

	# name=azure-rdma-driver-142
	# version=0.0.1
	mkdir azure-rdma-driver-142-0.0.1 

And place the module source code in it. The source code should be buildable with
`make -C /usr/src/linux-headers-$(uname -r) M="$PWD" modules`.

In the same directory, create a `dkms.conf` file. Example:

	firmware_version="142"
	PACKAGE_NAME="azure-rdma-driver-$firmware_version"
	PACKAGE_VERSION="0.0.1"
	DEST_MODULE_LOCATION[0]="/kernel/updates/dkms/" # It seems to be ignored in Ubuntu but still mandatory.
	BUILT_MODULE_NAME[0]="hv_network_direct"
	DEST_MODULE_NAME[0]="hv_network_direct_$firmware_version"

The `dkms.conf` file is just a shell script that is sourced by `dkms mkdsc`.
Note that `firmware_version` for instance is just a helper variable.

> All the supported variable are described in the `dkms` man page under the
> DKMS.CONF section.

Then run the `dkms mkdsc` to generate the source package:

	dkms mkdsc -m azure-rdma-driver-142 -v 0.0.1 --dkmsframework framework.conf

That will be placed in the `./dkms/` directory. Example:

	dkms/azure-rdma-driver-142/0.0.1/dsc/azure-rdma-driver-142-dkms_0.0.1.tar.gz

One alternative is to use this source package as a base to the final package.
For that some actions might be necessary:

- Remove the `*.dkms.tar.gz`.
- Update the copyright file.
- Update the changelog.
- Fix a few lintian errors.

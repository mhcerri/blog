---
title: Debugging the Ubuntu kernel with GDB and QEMU
date: 2018-01-23T13:58:17-02:00
tags:
- ubuntu
- kernel
- debug
- gdb
- qemu
---

This tutorial focuses on the practical aspects of preparing an Ubuntu libvirt
virtual machine to debug the ubuntu kernel.

Preparing the VM
----------------

Create an Ubuntu VM using `uvt-kvm` or `virt-manager` with the desired
configurations.

On the host machine, edit the VM domain XML:

	virsh edit "$GUESTNAME"

Replacing the first line:

	<domain type='kvm'>

With:

	<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
		<qemu:commandline>
			<qemu:arg value='-s'/>
		</qemu:commandline>

> `-s` tells QEMU to start a GDB server on port 1234 (it's equivalent to
> `-gdb tcp::1234`). `-S` can be appended to pause the VM before starting to run.

Optional configurations
-----------------------

### Serial console

With serial console, you can follow the guest boot via `virsh console` or
`virsh start --console`.

```
echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT console=tty0 console=ttyS0,38400n8"
GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"' |
sudo tee /etc/default/grub.d/99console.cfg
sudo update-grub
```

### mDNS daemon

With mDNS daemon you can access the VM via ssh using a `.local` domain.

On guest:

	apt-get install avahi-daemon

On host:

	ssh "${GUEST_USER}@${GUEST_DOMAIN}.local"

Obtaining the debug symbols
---------------------------

> In order to avoid including additional repositories to the host machines,
> the following steps uses the guest VM to download the debug packages.

On the guest, include the repository for debug packages:

	# Add repos
	echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse
	deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse
	deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" | \
	sudo tee -a /etc/apt/sources.list.d/ddebs.list
	# Import keys
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 428D7C01 C8CAB6595FDFF622
	# Update package list
	apt-get update

Install the package with the debug symbols for the current kernel:

	apt install "linux-image-$(uname -r)-dbgsym"
	
On the host, copy the debug symbol to some location:

	scp -r "${GUEST_USER}@${GUEST_DOMAIN}.local:/usr/lib/debug" /tmp/

Debugging the kernel
--------------------

Clone the corresponding kernel git repository, for example:

	git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/xenial linux-xenial
	cd linux-xenial
	git checkout Ubuntu-4.4.0-112.135

Start the VM (on a terminal apart):

	virsh start --console ""

Enable auto-loading of GDB scripts:

	echo "add-auto-load-safe-path $HOME" >> ~/.gdbinit

Start GDB pointing to the vmlinux:

	gdb -tui /tmp/debug/boot/vmlinux-4.4.0-112-generic

> Change the kernel version as appropriate

In GDB console, attach to the VM:

	target remote :1234

> (?) Load main kernel symbols: lx-symbols
> fakeroot debian/rules clean binary-headers binary-generic binary-perarch

Set the source path:

	set substitute-path /build/linux-HSAA8v/linux-4.4.0/ .

> The original base path will vary from kernel to kernel.

Set a breakpoint:

	b <some point>

And continue:

	c

> Use `Ctrl-x Ctrl-a` to switch to `tui` and follow the source code.


Links
-----

1. [RHEL - Debugging a kernel in QEMU/libvirt](https://access.redhat.com/blogs/766093/posts/2690881).
2. [Ubuntu Wiki - Debug Symbol Packages ](https://wiki.ubuntu.com/Debug%20Symbol%20Packages).
3. [GDB docs - Specifying Source Directories](https://sourceware.org/gdb/onlinedocs/gdb/Source-Path.html).

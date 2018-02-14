---
title: Kernel debug with GDB and QEMU
date: 2017-04-26T10:19:38-03:00
tags:
- kernel
- debug
- qemu
- gdb
---

This tutorial focuses on the practical aspects of preparing a QEMU system to 
debug the kernel with GDB.

The main goal of this tutorial is to quickly prepare a system for debugging:

   - In order to debug the kernel is necessary to keep the build root locally.
     Because of that, this tutoral focus on how to build a minimal kernel image
     that can be compiled in a few minutes.
   - Since the focus is the kernel, this tutorial makes use of pre-generated
     rootfs images to simplify the process.

Compiling a small kernel
------------------------

Using the default config as base:

	make alldefconfig

Enable serial console and init ram disk:

	make menuconfig

Search for the following configs and enable them:

	CONFIG_GDB_SCRIPTS
	CONFIG_SERIAL_8250
	CONFIG_SERIAL_8250_CONSOLE
	CONFIG_BLK_DEV_INITRD

> Use `/` to search for the config and type the corresponding number to go to
> the desired entry.

Enable better KVM support:

	make kvmconfig

Compile the kernel:

	time make -j"$(getconf _NPROCESSORS_ONLN)"

For x86, the kernel image will located at `arch/x86/boot/bzImage`.

Obtaining the pre-generated rootfs image
----------------------------------------

Download the correspondent system image for your architecture from this
[link](http://landley.net/aboriginal/bin/) and decompress it. The rootfs image
is located at `system-image-x86_64/rootfs.cpio.gz`.

Starting a virtual machine
--------------------------

The more basic command to start a VM is:

	qemu-system-x86_64 -enable-kvm -s \
		-kernel ./arch/x86_64/boot/bzImage \
		-initrd ./rootfs.cpio.gz -nographic \
		-append 'console=ttyS0'

`-s` tells QEMU to start a GDB server on port 1234. `-S` can be appended to
pause the VM before starting to run.

The virtual machine should start with console output.

Use `Ctrl-a c` to access the QEMU monitor console. Type `quit` from the monitor
console to finish the VM or `Ctrl-a c` to return to the VM console.

In order to share a directory from host with the VM (which might be useful for
testing out-of-tree modules), append the following arguments:

		-fsdev local,security_model=passthrough,id=fsdev-root,path="$DIR",readonly \
		-device virtio-9p-pci,id=fs-root,fsdev=fsdev-root,mount_tag=share

Replacing `$DIR` with the path to the directory to be shared.

Mount the tag `share` inside the guest:

	mount -t 9p share /mnt -o trans=virtio,version=9p2000.u

Debugging the kernel
--------------------

Enable auto-loading of GDB scripts:

	echo "add-auto-load-safe-path $HOME" >> ~/.gdbinit

Start gdb:

	gdb ./vmlinux

Attach to the VM:

	target remote :1234

Load main kernel symbols:

	lx-symbols

Set a breakpoint:

	b <some point>

And continue:

	c

> Use `Ctrl-x Ctrl-a` to switch to `tui` and follow the source code.


Links
-----

1. [Kernel documentation - Debugging kernel and modules via gdb](https://www.kernel.org/doc/html/latest/dev-tools/gdb-kernel-debugging.html).
   This page provides details about the main aspects of debugging the kernel with GDB.
2. [Pool of machine images and toolchains](http://landley.net/aboriginal/bin/).
   That's a good place to obtain pre-generated rootfs images for several
   architectures.
3. [How to Build A Custom Linux Kernel For Qemu](http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html).
   A good tutorial to build a small kernel to use with QEMU/KVM.
4. [Network lab with QEMU](https://vincent.bernat.im/en/blog/2012-network-lab-kvm).
   Tutorial that covers kernel debugging using qemu.

To do
-----

1. How to generate your own rootfs image.

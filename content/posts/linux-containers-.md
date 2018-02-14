---
date: 2015-12-07T11:43:55Z
tags:
- linux
- containers
- lxc
title: Linux containers 101
---

Linux containers (LXC) is a lightweight method of virtualization at the
operating system level. In a sentence it's a `chroot` on steroids providing
resources (CPU, memory, etc) isolation thanks to `cgroups`.

Install the necessary packages
===========================

To start with Linux containers, install the following packages:

```sh
# On ArchLinux
pacman -S lxc arch-install-scripts
lxc-checkconfig

# On Fedora
dnf install lxc lxc-extra lxc-templates
```

Configure the network
=====================

In this example, containers will be created by default with a ethernet pair
device connected to a bridge.

Add the following configuration to the file `/etc/lxc/defaults.conf`:

```sh
#
# Check `man lxc.container.conf` for more options.
#
lxc.network.type = veth
lxc.network.link = lxcbr0
lxc.network.flags = up
```

Every container created will inherit the configs from `defaults.conf`. In the
config above, `lxcbr0` is the name of the bridge that the virtual ethernet
devices will be connected to.

The next step is to create the bridge `lxcbr0`.

On Archlinux, create the file `/etc/netctl/lxcbr0`:

```sh
#
# Check `man netctl.profile` for more options.
#
Description="LXC bridge"
Interface=lxcbr0
Connection=bridge
IP=static
Address=192.168.100.1/24
```

And then:

```sh
netctl enable lxcbr0
netctl start lxcbr0
```

On Fedora (or any RHEL based ditro), create the file
`/etc/sysconfig/network-scripts/ifcfg-lxcbr0`:

```sh
VICE=lxcbr0
STP=yes
DELAY=2
BRIDGING_OPTS=priority=32768
TYPE=Bridge
BOOTPROTO=none
IPADDR=192.168.10.1
PREFIX=24
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=virbr0
ONBOOT=no
```

And then restart the network service.

> Both examples use static IP, but they can be changed to use dhcp.
>
> On systems that the `libvirt` creates a bridge as default (usually with
> dnsmask already running as a DHCP server), it's possible to skip the
> bridge configuration an use the bridge `virbr0` in the `defaults.conf`.

Creating containers
===================

The simplest way to create containers is from templates. The templates
available are located at `/usr/share/lxc/templates/`:

```console
$ ls /usr/share/lxc/templates/
lxc-alpine     lxc-cirros    lxc-openmandriva  lxc-ubuntu
lxc-altlinux   lxc-debian    lxc-opensuse      lxc-ubuntu-cloud
lxc-archlinux  lxc-download  lxc-oracle
lxc-busybox    lxc-fedora    lxc-plamo
lxc-centos     lxc-gentoo    lxc-sshd
```

To create a container from a template run the command bellow as root:

```sh
lxc-create -t centos -n container-name
```

Each template might require additional software in order to prepare the root
file system. For example, for CentOS it's necessary to have `yum` available in
your `$PATH` (on Arch Linux it's possible to install `yum` from AUR).

At the end, the command might show some instructions to setup your container,
the most common instruction is how to change the root password.

The `-n` indicates the name of the container to be created. Most of the LXC
commands, accepts (or requires) a container as target.

```sh
# List all containers
lxc-ls

# List all containers with details
lxc-ls -f

# Destroy a container
lxc-destroy -n container-name

# Get container's details
lxc-info -n container-name

# Start/stop a container
lxc-start -n container-name
lxc-stop -n container-name

# Attach to its console
lxc-console -n container-name

# Clone a container (use <Ctrl-a q> to exit)
lxc-clone container-name new-container-name
```

Container structure
===================

By default, a container is created at `/var/lib/lxc/container-name/`. This
directory usually container a `rootfs` directory and a `config` file.


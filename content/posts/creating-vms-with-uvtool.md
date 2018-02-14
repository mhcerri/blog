---
title: Creating VMs with uvtool
date: 2017-03-17T16:43:17-03:00
tags:
- ubuntu
- qemu
- uvtool
---

Use `uvtool` to create a machine:

	sudo apt install uvtool

Download cloud images with

	uvt-simplestreams-libvirt --verbose sync release=xenial arch=amd64

Images and meta-data are located under `/var/lib/uvtool/libvirt`.

	uvt-kvm create --cpu 2 --memory 2048 testvm release=xenial arch=amd64

`testvm` is the name of the VM. You can use that for various other commands:

	uvt-kvm wait --insecure testvm
	uvt-kvm ip testvm
	uvt-kvm ssh --insecure testvm

The `--insecure` is needed for ssh to disable host key verification.

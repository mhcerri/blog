---
title: Windows guests
date: 2017-07-10T09:08:35-03:00
tags:
- windows
- qemu
---

Useful links
------------

> PDF versions of these links were saved in `./windows-guests/`.

1. [Install Windows7 on KVM Qemu](https://github.com/hpaluch/hpaluch.github.io/wiki/Install-Windows7-on-KVM-Qemu)

	Steps on how to run a Windows guest on KVM with libvirt.

2. [QEMU Wiki: Features/GuestAgent](http://wiki.qemu.org/Features/GuestAgent)

	Details on what is needed to run the QEMU guest agent.

3. [Windows Guest Virtual Machines on Red Hat Enterprise Linux 7](https://access.redhat.com/articles/2470791)

	Tips for More Efficiency with Windows Guest Virtual Machines.

4. [Tutorial for fixing Error Code ‘0xc004c008′ in Windows 10 and Windows 8.1](https://www.techworm.net/2015/08/tutorial-for-fixing-error-code-0xc004c008′-in-windows-10-and-windows-8-1.html)

	Instruction on how to reactivate the Windows license on your VM.

5. [How to determine the version of DirectX by using the DirectX Diagnostic Tool](https://support.microsoft.com/en-us/help/157730/how-to-determine-the-version-of-directx-by-using-the-directx-diagnosti)

	How to check if you VM has support for DirectX.

Known issues
------------

- Windows 8.1 doesn't recognize the virtio driver for disks.
- Even with DirectX support in QXL, Fusion 360 shows poor performance.

To dos
------

- Include directly into this document the useful steps to create a Windows VM.

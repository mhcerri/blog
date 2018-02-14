---
date: 2015-08-04T09:11:01Z
tags:
- mk802
- fedora
title: How to fix load 1.0 issue on MK802
---

_Note: I'm currently using a Raspberry Pi 2 and Arch Linux ARM_

The load of my MK802 running Fedora 20 was constantly above 1.0. Checking the state of the processes I found:

```console
$ ps -eo pid,state,cmd | awk '$2 != "S" && $2 != "R"'
   34 D [usb-storage]
```

After searching on Google, I found that it seems to be a problem related to the OTG port. To fix we need to change some parameters in the `script.bin` file in the boot partition. This is a binary file, to disassembly it install the latest version of `sunxi-utils`:

```sh
cd /opt
git clone https://github.com/linux-sunxi/sunxi-tools
cd sunxi-tools
make
```

In the boot partition:

```sh
cd /boot
mv ./script.bin{,-bkp}
/opt/sunxi-tools/bin2fex ./script.bin-bkp ./script.fex
```

Edit the file `script.fex` and in the section `[usbc0]` change the following values:

```
usb_port_type = 1
usb_detect_type = 0
```

Generate the new binary `script.bin`

```sh
/opt/sunxi-tools/fex2bin ./script.fex ./script.bin
```

And reboot.

### References

1. http://linux-sunxi.org/Fex_Guide#USB_control_flags
2. https://ict-crew.nl/2013/09/high-load-average-fix/

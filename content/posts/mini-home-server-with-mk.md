---
date: 2015-08-04T09:02:39Z
tags:
- mk802
- linux
- fedora
title: Mini home server with MK802
---

_Note: I'm currently using a Raspberry Pi 2 and Arch Linux ARM_

My first attempt to set up a mini home server was using a [Raspberry Pi](http://www.raspberrypi.org/) as a torrent and a DLNA server running with an external HDD. Unfortunately it had a lot of USB related issues that caused the HDD and the network to disconnect very often. I tried several workarounds, from tweaks in the boot-loader to fixes in the kernel without success.

Because of that, almost two years ago I bought a [MK802](http://www.dx.com/p/mk802-mini-android-4-0-network-multi-media-player-w-wi-fi-hdmi-tf-white-eu-plug-152903) android stick from DealExtreme to replace my old Raspberry Pi. In general, the MK802 has been able to run a torrent and DLNA server for long periods of time without any further problems. But I noticed that sporadically the root FS was getting corrupted causing the MK802 to hang. Most of the times, a simple `fsck` was enough. But on the last hang the FS on the SD card was completely corrupted and I had to do a fresh reinstall.

The MK802 has an internal storage that comes with android pre-installed on it. The simplest way to get Linux running on it is using a SD card with one of several images available from [miniand](https://www.miniand.com/forums/forums/development/topics/mk802-guides-and-images) and [rikomagic](http://www.rikomagic.co.uk/forum/viewforum.php?f=2) sites. However I chose to use a Fedora 20 Remix for Allwinner A10's and A20's available [here](http://fedoraproject.org/wiki/Architectures/ARM/F20/Remixes) because it has a series of nice modules already compiled into it.

Considering that SD cards have limited write cycles and I was having FS corruptions with an increasing frequency, I decided to move the root partition to my external HDD. My first step was to copy the root partition to the external HDD and update the `root` parameter that uboot passes to the kernel with the new root partition. That can be done changing the `uEnv.txt` file in the boot partition:

```
console=tty0
loglevel=5
root=/dev/sda3 ro rootwait rootfstype=ext4
extraargs=console=ttyS0,115200 disp.screen0_output_mode=EDID:1280x720p60 hdmi.audio=EDID:0 sunxi_g2d_mem_reserve=0 sunxi_ve_mem_reserve=0 sunxi_fb_mem_reserve=20 sunxi_no_mali_mem_reserve
```

And.... that didn't work. After a few minutes investigating the original system booted from the SD card I noticed that the module needed to access USB storages was not built into the kernel. The only option was to rebuild the kernel including `usb-storage` in it.

## Rebuilding the Fedora 20 ARM for Allwinner A10 disk image

You can find all the instructions to rebuild the image in the [README file](http://fedorapeople.org/~lkundrak/a10-images/README). But I added bellow the steps that I did to rebuild my custom Fedora 20 disk image.

### Installing dependencies

Since we're going to cross-compile a new kernel targeting an ARM platform, we will need to install a few dependencies in addition to what is necessary to build a regular kernel. I had to install the following packages:

```
libusb1
gcc-arm-linux-gnu
uboot-tools
sunxi-tools
```

If your distro doesn't provide a package for `sunxi-tool` you can checkout its source from `https://github.com/linux-sunxi/sunxi-tools` and build it manually.

### Getting the sources

In order to generate the boot and root file systems and to create the disk image, _jwrdegoede_ has provided a series of git repositories containing the kernel source for A10 and A20 devices, kernel configs, board-specific files, and scripts that automatizes the building process.

The first repository to download is `sunxi-fedora-scripts`:

```sh
git clone https://github.com/jwrdegoede/sunxi-fedora-scripts.git
```

This repository contains the scripts to build the boot and root FS and to generate the disk image. All the other repositories need to be placed inside the `sunxi-fedora-scripts` directory:

```sh
cd ./sunxi-fedora-scripts/
git clone https://github.com/jwrdegoede/linux-sunxi.git
git clone https://github.com/jwrdegoede/sunxi-kernel-config.git
git clone https://github.com/jwrdegoede/sunxi-boards.git
git clone https://github.com/jwrdegoede/u-boot-sunxi.git
```

### Changing kernel config

That is the reason for all this process. We need to change the kernel config files to build `usb-storage` inside the kernel instead of as a module.

Edit `sunxi-kernel-config/config-generic` and change:

```
CONFIG_USB_STORAGE=m
```

To:

```
CONFIG_USB_STORAGE=y
```

### Generating the boot and root file systems

That is performed by the script `build-boot-root.sh`. It compiles a series of different boot-loaders and kernels to a big range of different boards. Since I just need support for MK802 that uses a sun4i chip, I changed the script to just build what was really necessary. That is my [modified script]().

After that you just need to run:

```
./build-boot-root.sh
```

This will create the files `uboot.tar.gz` and `rootfs.tar.gz`.

### Generating the disk image

The next step is to put everything together in a disk image that can be written to a SD card. That is done by the script `build-image.sh`, it uses the `uboot.tar.gz` and `rootfs.tar.gz` files located at the current directory and receives two arguments. The first one is a Fedora disk image for PandaBoard, the script will use it as a skeleton and replace everything that is necessary. The second argument is the output disk image file.

I intend to use my MK802 as a headless server, so instead of using the disk image for PandaBoard as input I decided to use an ARMHFP minimal disk image that can be downloaded [here](http://fedora.c3sl.ufpr.br/linux/releases/20/Images/armhfp/).

```sh
wget http://fedora.c3sl.ufpr.br/linux/releases/20/Images/armhfp/Fedora-Minimal-armhfp-20-1-sda.raw.xz
unxz Fedora-Minimal-armhfp-20-1-sda.raw.xz
./build-image.sh Fedora-Minimal-armhfp-20-1-sda.raw Fedora-Minimal-armhfp-20-1-sda.raw-USB.raw
```

### Preparing the hard drive disk

```sh
dd if=Fedora-Minimal-armhfp-20-1-sda.raw-USB.raw of=/dev/sdX
```

Notice that I'm copying the whole image to the external HDD, this will also copy the boot-loader and boot partition that will not be used. I opted to keep the same partition structure to avoid any further changes in the root partition to adjust mount point's UUIDs and anaconda scripts.

### Preparing the SD card

Since the root partition is not located at the SD card anymore I decided to save my 8GB SD card and use a smaller card with 256MB. The SD card will need to have a reserved region to the boot-loader and a boot partition (check the [linux-sunxi](http://linux-sunxi.org/Bootable_SD_card#Partitioning) site).

```sh
sfdisk -R /dev/mmcblk0
{ echo '1,16,c'; echo ',,L' } | sfdisk --in-order -uM /dev/mmcblk0
```

That will create the space needed to the boot-loader and a boot partition.

```sh
mkfs.ext3 /dev/mmcblk0p1
mount /dev/mmcnblk0p1 /mnt
tar -xzf ubootfs.tar.gz -C /mnt
cd /mnt
./select-board.sh mk802-1gb
cd -
umount /mnt
sync
```

That will copy all the necessary files and install the boot-loader.

### Final steps

The last thing to do is to insert the SD card and plug the external HHD, turn the device on and follow all the installer steps.

### References

1. https://fedoraproject.org/wiki/Architectures/ARM/F20/Remixes#Allwinner_A10_.2F_A13_.2F_A20
2. https://romanrm.net/a10/debian-hdd-root

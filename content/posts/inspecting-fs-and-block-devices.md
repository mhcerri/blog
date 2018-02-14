---
title: Inspecting file systems and block devices
date: 2017-03-09T11:04:16-03:00
tags:
- fs
- block devices
---

File system information
-----------------------

	sudo dumpe2fs /dev/<device>

Or for size information:

	sudo dumpe2fs /dev/<device> | grep size


Physical blocks of a file
-------------------------

	sudo PAGER=cat debugfs -R 'stat <file>' /dev/<device>

Notes:
-`<file>` must be relative to the file system.
-`-R` is used to give a direct command. Omit `-R '...'` to enter interactive
  mode.
-`PAGER=cat` ensures that no pager (as `less`) is used.

> Check `man debugfs` for additional commands.

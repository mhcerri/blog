---
date: 2015-11-23T22:49:34Z
tags:
- archlinux
- downgrade
title: Downgrading packages in Arch Linux
---

Arch Linux is a rolling release ditro and sometimes things get broken
and need to be downgraded.

There are several ways to that, but the easiest is installing from
the package cache. `cd` to the cache dir:

```sh
cd /var/cache/pacman/pkg/
```

Find the version of the package that you want to downgrade to and
install it using pacman:

```sh
pacman -U <file_name_of_the_package>
```

If the cache was cleaned, you can download a snapshot or rebuild the
package following the steps decribed in the
[Arch Linux wiki](https://wiki.archlinux.org/index.php/Downgrading_packages).


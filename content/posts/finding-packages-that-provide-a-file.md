---
date: 2015-12-26T19:30:08Z
tags:
- archlinux
- pacman
- pkgfile
title: Finding packages that provide a file
---

`yum` has a very useful feature used to find out
which package provides an specific file or a file
pattern.

`pacman` doesn't have such feature but it's possible
to get similar information using `pkgfile`.

To install `pkgfile`:

``` console
$ sudo pacman -S pkgfile
$ sudo pkgfile --update
```

And to search a package that contains a file, use the command:

``` console
$ pkgfile bash
core/bash
community/gulp
community/nodejs-grunt-cli
```

To get details about each match:

``` console
$ pkgfile -v bash
core/bash 4.3.042-4                 /usr/bin/bash
community/gulp 3.9.0-2              /usr/lib/node_modules/gulp/completion/bash
community/nodejs-grunt-cli 0.1.13-8 /usr/lib/node_modules/grunt-cli/completion/bash
```

It's also possible to match using the full path:

``` console
$ pkgfile -v /usr/bin/bash
core/bash 4.3.042-4 /usr/bin/bash
```

To perform a search similar to `yum provides`, using a glob pattern, use:

``` console
$ pkgfile -gv '*bin/bash'
core/bash 4.3.042-4 /usr/bin/bash
```


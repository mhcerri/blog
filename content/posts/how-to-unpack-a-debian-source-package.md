---
title: How to unpack a debian source package
date: 2017-06-29T09:13:29-03:00
tags:
- debian
- ubuntu
- deb
---

There are two kinds of Debian source packages: old ones and new ones.

A. Old ones look like this:

      hello-1.3-4.tar.gz
      hello-1.3-4.diff.gz

You unpack them by untaring the .tar.gz.  There is NO need to apply
the diff.

B. New ones look like this:

      hello_1.3-11.dsc
      hello_1.3-11.diff.gz
      hello_1.3-11.orig.tar.gz - note the `.orig` part

Here you MUST use dpkg-source or apply the diff manually - see below.

If you have `dpkg-source` you should put the files in the same
directory and type `dpkg-source -x <whatever>.dsc`.

If you do not you can extract the Debian source as follows:

1. untar `P_V.orig.tar.gz`.
2. rename the resulting `P-V.orig` directory to `P-V`.  If some other
   directory results, rename **it** to `P-V`.
3. `mkdir P-V/debian`.
4. apply the diff with patch -p0.
5. do `chmod +x P-V/debian/rules` (where `P` is the package name and `V`
   the version).

C. There are some packages where the Debian source is the upstream
 source.  In this case there will be no `.diff.gz` and you can just use
 the `.tar.gz`.  If a `.dsc` is provided you can use `dpkg-source -x`.

-- Ian Jackson <ijackson@gnu.ai.mit.edu>  Sat, 31 Aug 1996

Source
------
http://ftp.debian.org/debian/doc/source-unpack.txt

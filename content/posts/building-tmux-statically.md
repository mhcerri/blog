---
date: 2015-10-23T00:31:45Z
tags:
- tmux
title: Building tmux statically
---

Follow the steps:

```sh
yum groupinstall 'Development tools'
yum install glibc-static
# or
yum install compat-glibc
mkdir tmux
cd tmux
```

libevent
----------

```sh
curl -O -L 'https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz'
tar xf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable/
./configure --prefix=/tmp/local --disable-shared
make -j4
make install
cd ..
```

ncurses
-------

```sh
curl -O -L 'ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz'
tar xf ncurses-5.9.tar.gz
```

Apply the following patch or edit the file `./ncurses-5.9.orig/ncurses/base/MKlib_gen.sh` manually:

```diff
--- ./ncurses-5.9.orig/ncurses/base/MKlib_gen.sh	2011-01-22 17:47:29.000000000 -0200
+++ ./ncurses-5.9/ncurses/base/MKlib_gen.sh	2015-09-21 14:01:10.438925379 -0300
@@ -66,6 +66,24 @@ preprocessor="$1 -DNCURSES_INTERNALS -I.
 AWK="$2"
 USE="$3"
 
+  # A patch discussed here:
+  #   https://gcc.gnu.org/ml/gcc-patches/2014-06/msg02185.html
+  # introduces spurious #line markers into the preprocessor output.  The result
+  # appears in gcc 5.0 and (with modification) in 5.1, making it necessary to
+  # determine if we are using gcc, and if so, what version because the proposed
+  # solution uses a nonstandard option.
+  PRG=`echo "$1" | $AWK '{ sub(/^[[:space:]]*/,""); sub(/[[:space:]].*$/, ""); print; }' || exit 0`
+  FSF=`"$PRG" --version 2>/dev/null || exit 0 | fgrep "Free Software Foundation" | head -n 1`
+  ALL=`"$PRG" -dumpversion 2>/dev/null || exit 0`
+  ONE=`echo "$ALL" | sed -e 's/\..*$//'`
+  if test -n "$FSF" && test -n "$ALL" && test -n "$ONE" ; then
+      if test $ONE -ge 5 ; then
+          echo ".. adding -P option to work around $PRG $ALL" >&2
+          preprocessor="$preprocessor -P"
+      fi
+  fi
+
+
 PID=$$
 ED1=sed1_${PID}.sed
 ED2=sed2_${PID}.sed
```

> Copy the patch and paste it as input to the command:
>
>   patch -p1

Proceed with installation:

```sh
cd ncurses-5.9/
./configure --prefix=/tmp/local --with-default-terminfo-dir=/usr/share/terminfo  --with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo"
make -j 4
make install
cd ..
```

tmux
----

```sh
git clone 'https://github.com/tmux/tmux.git'
cd tmux
git checkout 1.9a
./autogen.sh
./configure --enable-static CFLAGS="-I/tmp/local/include -I/tmp/local/include/ncurses" LDFLAGS="-L/tmp/local/lib -L/tmp/local/include -L/tmp/local/include/ncurses" LIBEVENT_CFLAGS="-I/tmp/local/include" LIBEVENT_LIBS="-L/tmp/local/lib -levent"
make -j4

# Copy the binary:
cp ./tmux ~/bin
cd ..
```

References
----------

1. [Original post](http://pyther.net/2014/03/building-tmux-1-9a-statically/)

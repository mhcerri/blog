---
date: 2015-08-04T08:48:23Z
tags:
- python
- fedora
- linux
- pip
title: Installing Python from sources
---

Python is present in a large number of distros today and in fact most distros have at least one or more core components that are written or extensible using Python.

That is a good thing in the way that you can write Python application without any need to worry if Python will be available or not for ditro A or distro B. But it also creates some problems.

## Not all python modules are available via the distro package manager

There are thousands of modules and libraries available for Python, several of them are constantly updated. It's not rare the scenario where a stable python library is not availabthe distro repository or it's not updated.

## Different versions of Python are still in use

Sometimes your application will require a different python version than what's already installed in your target distro. Python provides good tools to deal with that problem, ranging from auto-conversion tools to `__future__` imports.

However sometimes you really need a different version and installing a newer one may cause conflicts in the system.

## Installing an alternative Python environment

The following steps show how to build and install an alternative Python environment from sources in a machine running Fedora.

!!! Important
    All commands in this section are intended to be used with Fedora.

### Installing necessary tools for building

```sh
sudo yum groupinstall "Development tools"
sudo yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
```

### Obtaining and compiling the sources.

```sh
wget http://python.org/ftp/python/3.3.5/Python-3.3.5.tar.xz
tar xf Python-3.3.5.tar.xz
cd ./Python-3.3.35/
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make
sudo make altinstall
```

`altinstall` is important here to avoid conflicts with the binaries provides by the distro.

## Using Pip and VirtualEnv to "install" additional modules and libraries

The fist step is to install Setuptools:

```sh
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
sudo /usr/local/bin/python3.3 ez_setup.py
```

Then Pip:

```sh
sudo /usr/local/bin/easy_install-3.3 Pip
```

And VirtualEnv:

```sh
sudo /usr/local/bin/pip3.3 install virtualenv
```

####References:

1. Based on <http://toomuchdata.com/2014/02/16/how-to-install-python-on-centos/>


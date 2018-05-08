---
title: "Managing Golang Dependencies With Wgo"
date: 2018-05-08T10:03:09-03:00
---

Simple way to handle dependencies for golang:

**Typical use**

```
$ mkdir myproject
$ cd myproject
$ wgo init
$ wgo get github.com/someone/dep
$ ls -a
.gocfg src vendor
$ mkdir src/myproj
$ emacs src/myproj/main.go
... import "github.com/someone/dep"
$ wgo install myproj
$ ./bin/myproj
it works!
$ git init
###$ wgo save > .gitignore
### Or instead:
echo '/vendor' >> .gitignore
$ git add .gocfg .gitignore src/myproj
$ git remote add origin https://foo.git
$ git push origin
```

**And later...**

```
$ git clone https://foo.git
$ cd foo
$ wgo restore
vendor/src/github.com/someone/dep
$ ls -a
.gocfg src vendor
$ wgo install myproj
$ ./bin/myproj
it works!
```

Source: https://github.com/skelterjohn/wgo

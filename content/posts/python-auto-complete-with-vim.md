---
date: 2015-10-23T00:15:00Z
tags:
- vim
- python
- jedi
- auto-complete
- archlinux
title: Python auto completion with Vim
---

Python auto completion in Vim is very well supported by Jedi.

However, to be fully functional Jedi and Vim should used the same python version.

The first step is to install the Vim with python3 support:

    pacman -S vim-python3

And then install the Jedi plugin for Vim:

    pacman -S python-jedi

That's all. Now open a `.py` file in Vim and use `Ctrl+Space` to get the completion options.

### Reference

1. [Vim Jedi](https://github.com/davidhalter/jedi-vim)


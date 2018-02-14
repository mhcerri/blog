---
date: 2015-12-14T14:37:01Z
tags:
- vim
- markdown
- snippet
title: Simple Vim snippet for markdown files
---

In markdown, fenced code blocks are handy because they allow you
to explicitly define the language to be used to highlight your code.

The only problem is that it's a bit painful to enter the triple backquotes
(<code>```</code>) with a non US keyboard.

To make it easier to write markdown documents, I use the following config
in my `~/.vimrc`:

``` vim
au BufNewFile,BufRead *.md iabbrev ''' ```
```

That way every time I type triple quotes (`'''`) followed by a new line
or a space it's replaced by the triple backquotes.

The only quirk here is that now it's necessary to separate with a space
the triple quotes from the language alias.

So I usually write code blocks this way:

<pre>
``` sh
echo "Hi"
```
</pre>

Instead of:

<pre>
```sh
echo "Hi"
```
</pre>

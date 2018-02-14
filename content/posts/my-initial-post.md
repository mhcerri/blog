---
date: 2015-08-03T23:22:06Z
tags:
- jekyll
- github pages
- blog
title: My initial post
---

I'm not a big fan of ruby and because of that I never used [Jekyll][jekyll], but since GitHub Pages uses it and I needed a place to keep my technical notes without having to worry with things such as web hosting and tons of configs I decided to give it a try.

GitHub Pages
------------

For the GitHub Page part, every necessary step is simply described in the [GitHub Pages][pages] site. Basically you need to follow 3 steps:

- Create a GitHub repository named `<username>.github.io`, in my case `mhcerri.github.io`.

- Clone it to your local machine.

	```console
	$ git clone https://github.com/username/username.github.io
	```

- And push your content;

    ```console
    $ cd username.github.io
    $ echo "Hello, World!" > index.html
    $ git add --all
    $ git commit -m 'Initial commit'
    $ git push origin master
    ```

Github Pages will serve any web content and will automatically process Jekyll files.

Jekyll installation
-------------------

There's no need to install Jekyll locally but you will need it if you want to preview your posts before publishing.

The recommended way to install Jekyll is via `gem` that is included in the `ruby` package in Arch Linux.

```console
# pacman -S ruby
```

You also will need to include your local gem installation directory to your PATH.

```console
$ export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
```

And then install Jekyll and GitHub pages package with its supported plugins.

```console
$ gem install jekyll
$ gem install github-pages
```

Bootstrap your blog
-------------------

To create a new Jekyll blog use the `new` command.

```console
$ cd ./username.github.io/
$ jekyll new .
```

Next, edit `_config.yaml` and `about.md`. I also recommend changing the default markdown engine from `kramdown` to `redcarpet`.

Take a look at the example post in `_posts` and remove it if you don't want to keep it.

To preview your blog use the `serve` command and then open the indicated URL in your browser.

```console
$ jekyll serve
```

Add a `.gitignore` file to exclude the generated content.

```console
$ echo _site >> .gitignore
```

Add push your blog to your GitHup repository.

```console
$ git add --all
$ git commit -m 'Add Jekyll basic blog'
$ git push origin master
```

Take a look at [Jekyll documentation](http://jekyllrb.com/docs/home/) to customize your blog.


[pages]:    https://pages.github.com/
[jekyll]:	http://jekyllrb.com/


---
date: 2015-08-04T01:06:01Z
tags:
- github pages
- jekyll
- blog
title: Using tags with Jekyll and GitHub Pages
---

Since GitHub Pages does not support third party plugins it's not possible to generate a page for each post tag without pushing a new file for each used tag.

However it's possible to use a single tag page with anchors to each tag.

The first step is to create a new tag page `tags.html`.

```html
{% raw %}
---
layout: page
title: Tags
permalink: /tags/
---
{% assign tags = site.tags | sort %}
{% for tag in tags %}
  {% assign tagname = tag | first | slugify %}
  <h3 id="{{ tagname }}">{{ tagname }}</h3>
  <ul>
  {% for post in tag[1] %}<li><a href="{{ post.url }}">{{ post.title }}</a></li>{% endfor %}
  </ul>
{% endfor %}
{% endraw %}
```

And then add the following piece of code to your `_layouts/post.html` file.

```html
{% raw %}
{% if page.tags %}Tags:
{% for tag in page.tags %}
  <a href="{{ site.baseurl }}/tags/#{{ tag | slugify }}">{{ tag | slugify }}</a>{% unless forloop.last %}, {% endunless %}
{% endfor %}
{% endif %}
{% endraw %}
```

That's all.

---
date: 2015-12-02T11:06:58Z
tags:
- nginx
- non-root
title: Running nginx as non-root user
---

This is a simple recipe to run nginx without privileges.

Create a configuration file with a simple proxy setup and redirecting most
of the needed files away from the default locations:

`nginx_dev.conf`:

```nginx
pid                 /tmp/nginx_dev/nginx.pid;
error_log           /tmp/nginx_dev/error.log;
worker_processes    1;

events {
	worker_connections 1024;
}

http {
	root        /tmp/nginx_dev/;
	access_log  /tmp/nginx_dev/access.log;

	client_body_temp_path   /tmp/nginx_dev/client_body/;
	fastcgi_temp_path       /tmp/nginx_dev/fastcgi/;
	proxy_temp_path         /tmp/nginx_dev/proxy/;
	scgi_temp_path          /tmp/nginx_dev/scgi/;
	uwsgi_temp_path         /tmp/nginx_dev/uwsgi/;

	include /etc/nginx/mime.types;

	server {
		listen 8001;

		location / {
			proxy_pass http://localhost:8000;
		}

		location /static/ {
			alias   /tmp/nginx_dev/static/;
		}
	}
}
```

All the necessary files will be created inside the directory `/tmp/nginx_dev`, that needs
to be created:

```sh
mkdir /tmp/nginx_dev
```

To start the nginx server, use the following command:

```sh
nginx -c "$PWD/nginx_dev.conf" -p /tmp
```

It's necessary to provide the full path of the configuration file and set the prefix
directory (`-p` option) to a location that your user has write permissions. The prefix
is used before the configuration file is read.

To automate this process, a `Makefile` can be used:

```make
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))

proxy-start:
	nginx -c $(current_dir)/nginx-dev.conf -p /tmp

proxy-stop:
	nginx -c $(current_dir)/nginx-dev.conf -p /tmp -s stop

proxy-reload:
	nginx -c $(current_dir)/nginx-dev.conf -p /tmp -s reload
```


---
date: 2015-11-18T14:50:43Z
tags:
- postgres
- postgresql
title: Standalone Postgres
---

This post covers a few basic concepts of Postgres and the steps to setup a
standalone Postgres server running without privileges.


All files related to a Postgres instance are stored in its data directory,
usually referenced as ``PG_DATA``. Usually the default location of 
``PG_DATA`` is ``/var/lib/pgsql/data`` or something similar (i.e.
``/var/lib/pgsql/9.4/data`` on CentOs) and this is the path used by the
standard instance controlled via the init service.

However, it's possible to initialize a new data directory on any path of
your choice and run a Postgres instance pointing to it.

```sh
initdb ./data
# Or, if initdb is not in your PATH (assuming Postgres 9.4):
/usr/pgsql-9.4/bin/initdb ./data
```

The file structure created by ``initdb`` is described in the [docs](http://www.postgresql.org/docs/current/static/storage-file-layout.html#STORAGE-FILE-LAYOUT).
But it's worth it to point the following files:

- ``postgresql.conf``: Main configuration file. 
- ``pg_hba.conf``: The host based access configuration file.
- ``recovery.conf``: Configuration file for standby instances.

The default configuration has sane values, and in order to run it without
privileges just a few changes are needed.

```sh
cd ./data

# Optional: remove noisy comments:
mv postgresql.conf postgresql.conf.orig
sed -e 's/#.*//' postgresql.conf.orig | grep -vE '^\s*$' > postgresql.conf
```

And add the following lines to ``postgresql.conf``:

```sh
unix_socket_directories = '/tmp'
port = 7777
```

And then run ``postgres`` pointing to the new data directory:

```sh
postgres -D .
# Or:
pg_ctl start -D .
```

How you can connect to the new Postgres instance and work normally:

```console
$ psql -h localhost -p 7777 postgres
CREATE USER usr ENCRYPTED PASSWORD 'dummy';
CREATE DATABASE db OWNER usr;
\q

$ psql -h localhost -p 7777 db usr
CREATE TABLE tb (id INTEGER PRIMARY KEY);
\q
```

Useful links
------------

- http://www.postgresql.org/docs/9.4/static/index.html

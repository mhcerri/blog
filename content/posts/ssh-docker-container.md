---
title: How to create a docker container with SSH
date: 2017-10-03T10:47:54-03:00
tags:
- docker
- containers
- ssh
---

That also starts automatically with dockerd.

Steps
-----

```
$ cat > Dockerfile << 'END'
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
END

$ docker build -t ssh .

# -d	Detach from terminal.
# -P	Publish all exposed ports to random ports on the host interfaces.
$ docker run -d -P --restart=always --name ssh0 ssh

$ docker port ssh0 22
```

Links
-----

- [Start containers automatically](https://docs.docker.com/engine/admin/start-containers-automatically/).
- [Dockerize an SSH service](https://docs.docker.com/engine/examples/running_ssh_service/).

---
date: 2015-12-14T09:42:46Z
tags:
- ssh
- portforwarding
title: Restricting user for SSH port forwarding
---

This is a very basic configuration for the SSH daemon to restrict
a user to be used only for port forwarding with public key authentication.
These steps does not cover any form of `chroot` or sandbox.

First step: create a user and his base home directory structure:

``` sh
useradd dummy
mkdir -p /home/dummy/.ssh
```

On the remote host, generate a pair of keys if needed:

``` sh
ssh-keygen -b 4096 -t rsa
```

Copy the file `id_rsa.pub` to a temporary location on your server and add its
content to the `.ssh/authorized_keys` file:

``` sh
cat /tmp/id_rsa.pub >> /home/dummy/.ssh/authorized_keys
```

Adjust permissions to not allow the user himself to write to his home:

``` sh
chown -R root /home/dummy
find /home/dummy -type d -exec chmod 755 {} \;
chmod 644 /home/dummy/.ssh/authorized_keys
```

The result tree should look like the following:

``` console
$ find /home/dummy -exec stat -c '%A %U:%G %n' {} \;
drwxr-x--- root:dummy /home/dummy
drwxr-x--- root:dummy /home/dummy/.ssh
-rw-r--r-- root:dummy /home/dummy/.ssh/authorized_keys
```

The next step is to tell the SSH daemon to use specific configurations
for the new user. Add the following lines to the file `/etc/ssh/sshd_config`
and restart the SSH daemon.

```
Match User dummy
		# Allow remote only forwarding (-R)
		AllowTcpForwarding remote
		# Disallow tun devices
		PermitTunnel no
		# Disallow X11 forwarding for less exposure
		X11Forwarding no
		# Allow remote port forwarding to bind to non-loopback interfaces
		GatewayPorts yes
		# Disallow external authentication agents
		AllowAgentForwarding no
		# Restrict forwarding only to ports allowed
		PermitOpen 127.0.0.1:8888
		# Restrict shell
		ForceCommand echo 'This account is restricted'
```

Check `man sshd_config` for more options.


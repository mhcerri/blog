---
title: Setting up an OpenVPN server
date: 2018-02-11T18:31:20-02:00
tags:
- openvpn
- vpn
---

> These steps are intended to be used with Arch Linux but
> can be easily adapted to Ubuntu.

> TODO: Convert to ubuntu/debian.

System requirements
-------------------

The kernel needs to be compiled with TUN/TAP support.

Packages
--------

Install the following packages:

	pacman -S openvpn easy-rsa
	apt-get install openvpn easy-rsa # TODO

For `ovpn` client files generation:

	aurget -S ovpngen

> TODO: how to install `ovpngen` on Ubuntu.

Public Key Infrastructure (PKI)
-------------------------------

> For security purposes it's recommended to use separate machines for
> server, client and CA.

*Certificate Authority (CA)*

	mkdir ca
	cd ca/
	cp /etc/easy-rsa/{openssl-easyrsa.cnf,vars,x509-types} .
	export EASYRSA=$(pwd)
	easyrsa init-pki
	easyrsa build-ca
	sudo cp pki/ca.crt /etc/openvpn/server/

*Server certificate and private key*


	# Use any server name you prefer. However keeping it as `server`,
	# simplify the server configuration since that's the name used
	# by the example configuration.
	SERVER=server

	cd ..
	mkdir server
	cd server/
	cp /etc/easy-rsa/{openssl-easyrsa.cnf,vars,x509-types} .
	export EASYRSA=$(pwd)
	easyrsa init-pki
	easyrsa gen-req "$SERVER" nopass
	sudo cp pki/private/"$SERVER.key" /etc/openvpn/server/

*Diffie-Hellman (DH) parameters file*

	sudo openssl dhparam -out /etc/openvpn/server/dh.pem 2048

*Hash-based Message Authentication Code (HMAC) key*

	sudo openvpn --genkey --secret /etc/openvpn/server/ta.key

*Client certificate and private key*

> Repeat the client steps for each client.

	# Use any server name you prefer. However keeping it as `server`,
	CLIENT=client1

	cd ..
	mkdir "$CLIENT"
	cd "$CLIENT/"
	cp /etc/easy-rsa/{openssl-easyrsa.cnf,vars,x509-types} .
	export EASYRSA=$(pwd)
	easyrsa init-pki
	easyrsa gen-req "$CLIENT" nopass

*Signing client and server certificates*

	cd ../ca/
	export EASYRSA=$(pwd)

	# Server:
	cp ../server/pki/reqs/*.req .
	easyrsa import-req "$SERVER.req" "$SERVER"
	easyrsa sign-req server "$SERVER"
	cp pki/issued/"$SERVER.crt" /etc/openvpn/server/

	# Client:
	cp ../"$CLIENT"/pki/reqs/*.req .
	easyrsa import-req "$CLIENT.req" "$CLIENT"
	easyrsa sign-req server "$CLIENT"
	mkdir ../"$CLIENT"/pki/signed
	cp pki/issued/"$CLIENT.crt" ../"$CLIENT"/pki/signed/

Server configuration
--------------------

	cp /usr/share/openvpn/examples/server.conf /etc/openvpn/server/server.conf

Edit `/etc/openvpn/server/server.conf` change at least:

	ca ca.crt
	cert ${SERVER}.crt
	key ${SERVER}.key  # This file should be kept secret
	tls-crypt ta.key # Replaces tls-auth ta.key 0
	user nobody
	group nobody
	port ${PORT}

It's a good practice to use a port `$PORT` different than the default value of 1194.

Make the local network available to clients (using `192.168.0.0/24` as example):

	push "route 192.168.0.0 255.255.255.0"

Force all traffic through the VPN:

	push "redirect-gateway def1 bypass-dhcp"

Compress traffic:

	comp-lzo

Harden server:

	# Hardening
	auth SHA512
	tls-version-min 1.2
	tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:TLS-DHE-RSA-WITH-AES-256-CBC-SHA:TLS-DHE-RSA-WITH-CAMELLIA-256-CBC-SHA:TLS-DHE-RSA-WITH-AES-128-CBC-SHA:TLS-DHE-RSA-WITH-CAMELLIA-128-CBC-SHA

Firewall configuration (UFW)
----------------------------

In `/etc/default/ufw`:

	DEFAULT_FORWARD_POLICY="ACCEPT"

In the beginning of `/etc/ufw/before.rules`:

	# NAT (Network Address Translation) table rules
	*nat
	:POSTROUTING ACCEPT [0:0]

	# Allow traffic from clients to eth0
	-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

	# do not delete the "COMMIT" line or the NAT table rules above will not be processed
	COMMIT

> Use the corresponding network configured in `/etc/openvpn/server/$SERVER.conf`.

Run:

	ufw allow "$PORT"
	ufw reload

Start OpenVPN server
--------------------

For tests:

	sudo su
	cd /etc/openvpn/server/
	openvpn "$SERVER.conf"

Via `systemd`:

	systemctl enable "openvpn-server@$SERVER"
	systemctl start "openvpn-server@$SERVER"

Generate `ovpn` file for client
-------------------------------

	cd ../"$CLIENT"/
	sudo ovpngen                         \
	      "$SERVER"                      \
	      "$PWD/../ca/pki/ca.crt"        \
	      "$PWD/pki/signed/$CLIENT.crt"  \
	      "$PWD/pki/private/$CLIENT.key" \
	      /etc/openvpn/server/ta.key     \
	      > "$CLIENT.ovpn"

Edit `$CLIENT.ovpn` and update the following:

1. Port number and protocol type in the `remote` configuration.
2. Update `cipher`, `auth`, `comp-lzo` and similar configurations to match your server configuration.

Transfer the `.ovpn` file to your android device and import it on the OpenVPN app.

> TODO: NetworkManager configuration

Links
-----

1. https://wiki.archlinux.org/index.php/OpenVPN
2. https://wiki.archlinux.org/index.php/Easy-RSA
3. https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04

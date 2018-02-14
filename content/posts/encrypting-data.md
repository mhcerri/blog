---
title: Simple way to encrypt and decrypt data
date: 2017-02-04T17:01:14-02:00
tags:
- encryption
- openssl
---

Encrypting
----------

With `openssl`:

	openssl enc -aes-256-cbc -salt -a

Then type the password twice, type or paste the clear text and hit enter
followed by `ctrl-d` twice.

Decrypting
----------

With `openssl`:

	openssl enc -aes-256-cbc -salt -a -d

Then type the password once, type or paste the cipher text and hit enter
followed by `ctrl-d` twice.

---
title: Serial console on VMs
date: 2017-08-09T13:27:28-03:00
tags:
- serial
- systemd
---

1. Add the file:

```
cat > /etc/default/grub.d/99console.cfg << EOF
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT console=tty0 console=ttyS0,38400n8"
GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"
EOF
```

2. Update grub:

```
sudo update-grub
```

References
----------

1. [Configure console access on the target machine](https://wiki.archlinux.org/index.php/working%20with%20the%20serial%20console#Configure_console_access_on_the_target_machine)

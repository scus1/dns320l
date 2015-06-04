# Linux on D-Link DNS-320L

Building the kernel
-------------------

```bash
$ cd kernel/
$ wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.XX.XX.tar.xz
$ tar xzJ linux-3.XX.XX.tar.xz
$ cd linux-3.XX.XX/
$ sh ../configure.sh
$ sh ../build.sh
$ sh ../install.sh
```

MCU
------------
TODO




References
----------
* [Linux on the D-Link DNS-320L][boe]
* [Debian @ Dlink DNS-327L: The guide][nec]
* [Debian Linux on the D-Link DNS-320 & DNS-325 NAS][len]


[nec]: http://ncrmnt.org/wp/2015/02/15/debian-dlink-dns-327l-the-guide/
[boe]: http://www.aboehler.at/doku/doku.php/projects:dns320l
[len]: http://jamie.lentin.co.uk/devices/dlink-dns325/

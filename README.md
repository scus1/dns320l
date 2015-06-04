# Linux on D-Link DNS-320L

Works sofar with
* linux-3.14.43
* linux-4.0.4

Install cross compiler toolchain
--------------------------------

* [Debian Jessie][deb-cross]
    ```bash
    $ cat - <<EOF | sudo tee /etc/apt/sources.list.d/crosstools.list 
    deb http://emdebian.org/tools/debian/ jessie main
    EOF
    $ curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -
    $ sudo dpkg --add-architecture armel
    $ sudo apt-get update
    $ sudo apt-get install crossbuild-essential-armel
    ```

* Ubuntu 14.04
    ```bash
    $ sudo apt-get install gcc-arm-linux-gnueabi
    ```

[deb-cross]: https://wiki.debian.org/CrossToolchains#Installation

Building the kernel
-------------------

```bash
$ cd kernel/
$ wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.XX.XX.tar.xz
$ tar xzJ linux-X.XX.XX.tar.xz
$ cd linux-X.XX.XX/
$ sh ../configure.sh
$ sh ../build.sh
$ sh ../install.sh
$ sh ../package-deb.sh
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

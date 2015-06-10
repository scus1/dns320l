# Linux on D-Link DNS-320L

**Warning:** I take no responsibility if you screw up your device following these instructions. Proceed at your own risk and use your own head. This will probably void warranty.

I have tested these instructions successfully with:
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

You can now build the kernel using `cross-make` defined as follows:
```bash
$ alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'
```

For the lazy people out there, a Makefile is included (see next section).

[deb-cross]: https://wiki.debian.org/CrossToolchains#Installation


Building the kernel
-------------------
Get the kernel source from `kernel.org` or `github.com/torvalds/linux` and place them into the `kernel/` subdir:
```bash
$ cd kernel/
$ wget https://www.kernel.org/pub/linux/kernel/vX.x/linux-X.XX.XX.tar.xz
$ tar xzJ linux-X.XX.XX.tar.xz
```

You now have to configure the kernel:
```bash
$ make config
```
This command takes `kirkwood_defconfig` respectively `mvebu_v5_defconfig`, adds the options defined in `config.d/*`,  copies the `kirkwood-dns320l.dts` to the appropriate location and finally lets you modify the configuration using `menuconfig`. You may modify the `.config` as you like.


To create the kernel image run
```bash
$ make build
```
which builds the kernel, appends the device tree blob and builds the `uImage` and modules.


Finally you may want to run
```bash
$ make DESTDIR=<root_of_your_nas> install
```
which installs the uImage and modules into the appropriate directories under $DESTDIR, or
```bash
$ make deb
```
which creates a Debian package containing the uImage and modules.


**Remark:** These make targets try to find the latest kernel sources via `ls -1 -d */ | sort -r | head -n 1`. If you want to build another kernel version, you have to provide the path via `SRC_DIR`, i.e. `make SRC_DIR=linux-X.XX.XX/ config|build|install|deb`.

**Attention**: The installation of the package does not flash the image. You have to do this on your own! You should, at first, try to boot your kernel using a USB Stick (see [Booting the NAS](http://jamie.lentin.co.uk/devices/dlink-dns325/keeping-original-firmware/#booting-the-nas)). Afterwards you may flash the kernel to NAND (see [Installing kernel to NAND](http://jamie.lentin.co.uk/devices/dlink-dns325/keeping-original-firmware/#installing-kernel-to-nand)).

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

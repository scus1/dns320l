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

[deb-cross]: https://wiki.debian.org/CrossToolchains#Installation

Building the kernel
-------------------
Get the kernel source from `kernel.org` or `github.com/torvalds/linux` and place them into the `kernel/` subdir and change to the source directory:
```bash
$ cd kernel/
$ wget https://www.kernel.org/pub/linux/kernel/vX.x/linux-X.XX.XX.tar.xz
$ tar xzJ linux-X.XX.XX.tar.xz
$ cd linux-X.XX.XX/
```
You now have to configure the kernel:
```bash
$ sh ../configure.sh
```
This command takes `kirkwood_defconfig` respectively `mvebu_v5_defconfig`, adds the options defined in `config.d/*`,  runs `cross-make menuconfig` and copies the `kirkwood-dns320l.dts` to the appropriate location. You may modify the `.config` as you like.


To create the kernel image run
```bash
$ sh ../build.sh
```
which executes `cross-make zImage`, `cross-make kirkwood-dns320l.dtb`, appends the device tree blob, builds the `uImage` and the modules.


```bash
$ sh ../install.sh
```
now creates the subdir `linux-image-$KERNELRELEASE` and installs the `uImage` and modules to it.

With
```bash
$ sh ../package-deb.sh
```
you may now create a Debian package (`linux-image-$KERNELRELEASE.deb`) to install the kernel and modules to your NAS. 

**Attention**: The installation of the package does not flash the image. You have to do this on your own! You should, at first, try to boot your kernel using a USB Stick (see [Booting the NAS][http://jamie.lentin.co.uk/devices/dlink-dns325/keeping-original-firmware/#booting-the-nas]). Afterwards you may flash the kernel to NAND (see [Installing kernel to NAND][http://jamie.lentin.co.uk/devices/dlink-dns325/keeping-original-firmware/#installing-kernel-to-nand]).

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

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
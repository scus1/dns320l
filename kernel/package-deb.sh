
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

RELEASE=$(cross-make kernelrelease)
DESTDIR="./linux-image-$RELEASE"

mkdir -p $DESTDIR/DEBIAN

read -p "Maintainer (your name): " MAINTAINER
cat - <<EOF > $DESTDIR/DEBIAN/control
Package: linux-image-$RELEASE
Version: $RELEASE
Section: kernel
Priority: important
Architecture: armel
Installed-Size: 1
Maintainer: $MAINTAINER
Description: Linux kernel for D-Link DNS-320L
EOF

dpkg-deb -b linux-image-$RELEASE
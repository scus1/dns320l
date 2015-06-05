
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

RELEASE=$(cross-make -s kernelrelease)
DESTDIR="./linux-image-$RELEASE"

mkdir -p $DESTDIR/DEBIAN

VERSION=$(date +"%Y.%m.%d-%H%M")
SIZE=$(du -sk $DESTDIR | awk '{print $1}')

read -p "Maintainer (your name): " MAINTAINER
cat - <<EOF > $DESTDIR/DEBIAN/control
Package: linux-image-$RELEASE
Version: $VERSION
Section: kernel
Priority: important
Architecture: armel
Installed-Size: $SIZE
Maintainer: $MAINTAINER
Description: Linux kernel for D-Link DNS-320L
EOF

dpkg-deb -b linux-image-$RELEASE
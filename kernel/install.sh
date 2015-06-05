
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

RELEASE=$(cross-make -s kernelrelease)
DESTDIR="./linux-image-$RELEASE" 
echo "Installing to $DESTDIR"

mkdir -p $DESTDIR/boot
cp arch/arm/boot/uImage $DESTDIR/boot/uImage-$RELEASE || exit 1

cross-make INSTALL_MOD_PATH=$DESTDIR modules_install || exit 1
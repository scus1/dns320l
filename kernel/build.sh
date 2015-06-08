
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

RELEASE=$(cross-make kernelrelease)
echo "Building $RELEASE"

echo "Building kernel image"
cross-make -j8 zImage kirkwood-dns320l.dtb || exit 1

echo "Appending DTB"
cat arch/arm/boot/dts/kirkwood-dns320l.dtb >> arch/arm/boot/zImage || exit 1

echo "Building uImage"
cross-make LOADADDR=0x00008000 uImage || exit 1

echo "Building modules"
cross-make -j8 modules || exit 1
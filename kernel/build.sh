
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

RELEASE=$(cross-make kernelrelease)
echo "Building $RELEASE"

cross-make -j8 zImage kirkwood-dns320l.dtb || exit 1
cat arch/arm/boot/dts/kirkwood-dns320l.dtb >> arch/arm/boot/zImage || exit 1

cross-make uImage || exit 1
cross-make -j8 modules || exit 1
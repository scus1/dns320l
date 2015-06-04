
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

RELEASE=$(cross-make kernelrelease)
echo "Building $RELEASE"

cross-make -j8 zImage kirkwood-dns320l.dtb
cat arch/arm/boot/kirkwood-dns320l.dtb >> arch/arm/boot/zImage

cross-make uImage
cross-make -j8 modules
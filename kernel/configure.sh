
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

find ../config.d -type f -print0 | sort -z | xargs -0 cat > .config
cp ../dts/kirkwood-dns320l.dts arch/arm/boot/dts/

cross-make menuconfig
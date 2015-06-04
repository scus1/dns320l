
alias cross-make='make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

if [ -n "$1" ]; then
    echo "Using config at $1"
    cp $1 .config
elif [ -f arch/arm/configs/kirkwood_defconfig ]; then
    echo "Using kirkwood_defconfig"
    cp arch/arm/configs/kirkwood_defconfig .config
elif [ -f arch/arm/configs/mvebu_v5_defconfig ]; then
    echo "Using mvebu_v5_defconfig"
    cp arch/arm/configs/mvebu_v5_defconfig .config
else
    echo "Don't know with what .config to start. Aborting..."
    exit 1
fi

echo "Applying configuration from config.d"
find ../config.d -type f -print0 | sort -z | xargs -0 cat >> .config
cp ../dts/kirkwood-dns320l.dts arch/arm/boot/dts/

cross-make menuconfig

ifndef SRC_DIR
$(error SRC_DIR not set)
endif

.PHONY: config build install

ARCH           = arm
CROSS_COMPILE  = arm-linux-gnueabi-
CROSS_MAKE    := $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)

RELEASE        = $(shell $(CROSS_MAKE) -C $(SRC_DIR) -s kernelrelease)
DESTDIR        = ./linux-image-$(RELEASE)
DESTDIR       := $(abspath $(DESTDIR))


INSTALL = install

config:
ifdef CONFIG
	cp $(CONFIG) $(SRC_DIR)/.config
else ifneq "$(wildcard $(SRC_DIR)/arch/arm/configs/kirkwood_defconfig)" ""
	cp $(SRC_DIR)/arch/arm/configs/kirkwood_defconfig $(SRC_DIR)/.config
else ifneq "$(wildcard $(SRC_DIR)/arch/arm/configs/mvebu_v5_defconfig)" ""
	cp $(SRC_DIR)/arch/arm/configs/mvebu_v5_defconfig $(SRC_DIR)/.config
else
	$(error I don't know with what .config i should start)
endif
	find ./config.d -type f -print0 | sort -z | xargs -0 awk 'FNR==1{print ""}1' >> $(SRC_DIR)/.config
	cp ./dts/kirkwood-dns320l.dts $(SRC_DIR)/arch/arm/boot/dts/

	$(CROSS_MAKE) -C $(SRC_DIR) menuconfig


build:
	$(CROSS_MAKE) -C $(SRC_DIR) -j8 zImage kirkwood-dns320l.dtb
	cat $(SRC_DIR)/arch/arm/boot/dts/kirkwood-dns320l.dtb >> $(SRC_DIR)/arch/arm/boot/zImage
	$(CROSS_MAKE) -C $(SRC_DIR) LOADADDR=0x00008000 uImage
	$(CROSS_MAKE) -C $(SRC_DIR) -j8 modules

install:
	$(INSTALL) -d $(DESTDIR)/boot
	$(INSTALL) $(SRC_DIR)/arch/arm/boot/uImage $(DESTDIR)/boot/uImage-$(RELEASE)
	$(CROSS_MAKE) -C $(SRC_DIR) INSTALL_MOD_PATH=$(DESTDIR) modules_install




.PHONY: config build install deb deb_control

ARCH           = arm
CROSS_COMPILE  = arm-linux-gnueabi-
CROSS_MAKE    := $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)


ifndef DESTDIR
DESTDIR       := /
else
DESTDIR       := $(abspath $(DESTDIR))
endif

ifndef SRC_DIR
SRC_DIR := $(shell ls -1 -d */ | grep -e '^linux-' | sort -r | head -n 1)
endif
SRC_DIR := $(abspath $(SRC_DIR))

ifneq "$(wildcard $(SRC_DIR)/.config)" ""
RELEASE = $(shell $(CROSS_MAKE) -C $(SRC_DIR) -s kernelrelease)
else
RELEASE = noconfig
endif


help:
	@echo 'Targets:'
	@echo '  config  - Generate .config file in $$SRC_DIR'
	@echo '            (this command takes the default config, adds the'
	@echo '            configuration in ./config.d and runs "make menuconfig")'
	@echo '  build   - Build the uImage and modules in $$SRC_DIR'
	@echo '  install - Install uImage and modules to $$DESTDIR (default: /)'
	@echo '  deb     - Build Debian package'
	@echo '            (this target invokes the "install" to install the'
	@echo '            uImage and modules to a temporary directory'
	@echo '            (./tmp/linux-image-$$RELEASE); you may modify the DEBIAN/control'
	@echo '            file under this directory and remake this target)'

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
	install -d $(DESTDIR)/boot
	install $(SRC_DIR)/arch/arm/boot/uImage $(DESTDIR)/boot/uImage-$(RELEASE)
	$(CROSS_MAKE) -C $(SRC_DIR) INSTALL_MOD_PATH=$(DESTDIR) modules_install

deb: TMP_DIR := $(abspath ./tmp/linux-image-$(RELEASE))
deb:
	$(MAKE) -s DESTDIR=$(TMP_DIR) install
	$(MAKE) -s DESTDIR=$(TMP_DIR) deb_control
	dpkg -b $(TMP_DIR) linux-image-$(RELEASE).deb

deb_control: VERSION = $(shell date +"%Y.%m.%d-%H%M")
deb_control: SIZE    = $(shell du -sk $(DESTDIR) | cut -f1)
deb_control:
ifeq "$(wildcard $(DESTDIR)/DEBIAN/control)" ""
	@install -d $(DESTDIR)/DEBIAN
	@echo 'Package: linux-image-$(RELEASE)'               >  $(DESTDIR)/DEBIAN/control
	@echo 'Version: $(VERSION)'                           >> $(DESTDIR)/DEBIAN/control
	@echo 'Section: kernel'                               >> $(DESTDIR)/DEBIAN/control
	@echo 'Priority: important'                           >> $(DESTDIR)/DEBIAN/control
	@echo 'Architecture: armel'                           >> $(DESTDIR)/DEBIAN/control
	@echo 'Installed-Size: $(SIZE)'                       >> $(DESTDIR)/DEBIAN/control
	@echo 'Maintainer: $(USER)'                           >> $(DESTDIR)/DEBIAN/control
	@echo 'Description: Linux kernel for D-Link DNS-320L' >> $(DESTDIR)/DEBIAN/control

	editor $(DESTDIR)/DEBIAN/control
else
	@echo 'Found control file, just updating version and size field'
	@sed -e 's/^Version: .*/Version: $(VERSION)/g' -i $(DESTDIR)/DEBIAN/control
	@sed -e 's/^Installed-Size:: .*/Installed-Size: $(SIZE)/g' -i $(DESTDIR)/DEBIAN/control
endif




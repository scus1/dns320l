
DESTDIR = /

VERSION := $(shell git show -s --format=%ct)
ifneq "$(shell git diff --shortstat 2> /dev/null | tail -n1)" ""
VERSION := $(VERSION)-dirty
endif

.PHONY: help install install_tools install_systemd_config deb

help:
	@echo 'Targets:'
	@echo '  install                - Install scripts and systemd service files to $$DESTDIR'
	@echo '  install_tools          - Install scripts to $$DESTDIR'
	@echo '  install_systemd_config - Install systemd service files to $$DESTDIR'
	@echo '  deb                    - Build Debian package'
	@echo '                           (this target creates a temporary directory "tmp" to create'
	@echo '                           the package)'
	@echo ' '
	@echo 'The default value for $$DESTDIR is $(DESTDIR)'

install: install_tools install_systemd_config

install_tools:
	install -d $(DESTDIR)/usr/bin
	install -m 0755 mcu/mcu_communicate.py   $(DESTDIR)/usr/bin/mcu_communicate
	install -m 0755 hddwatch/hddwatch.sh     $(DESTDIR)/usr/bin/hddwatch
	install -m 0755 fancontrol/fancontrol.sh $(DESTDIR)/usr/bin/fancontrol
	install -d $(DESTDIR)/etc/default
	install fancontrol/fancontrol_default    $(DESTDIR)/etc/default/fancontrol

install_systemd_config:
	install -d $(DESTDIR)/lib/systemd/system
	install hddwatch/hddwatch.service     $(DESTDIR)/lib/systemd/system
	install fancontrol/fancontrol.service $(DESTDIR)/lib/systemd/system
	install device_failure.service        $(DESTDIR)/lib/systemd/system
	install device_ready.service          $(DESTDIR)/lib/systemd/system
	install device_poweroff.service       $(DESTDIR)/lib/systemd/system

deb: TMP_DIR := $(abspath ./tmp/)
deb:
	$(MAKE) -s DESTDIR=$(TMP_DIR) install
	$(MAKE) -s DESTDIR=$(TMP_DIR) deb_control
	dpkg -b $(TMP_DIR) dns320l-tools.deb

deb_control: SIZE = $(shell du -sk $(DESTDIR) | cut -f1)
deb_control:
	@install -d $(DESTDIR)/DEBIAN
ifeq "$(wildcard $(DESTDIR)/DEBIAN/control)" ""
	@echo 'Package: dns320l-tools'                 >  $(DESTDIR)/DEBIAN/control
	@echo 'Version: $(VERSION)'                    >> $(DESTDIR)/DEBIAN/control
	@echo 'Section: misc'                          >> $(DESTDIR)/DEBIAN/control
	@echo 'Priority: important'                    >> $(DESTDIR)/DEBIAN/control
	@echo 'Architecture: armel'                    >> $(DESTDIR)/DEBIAN/control
	@echo 'Installed-Size: $(SIZE)'                >> $(DESTDIR)/DEBIAN/control
	@echo 'Maintainer: $(USER)'                    >> $(DESTDIR)/DEBIAN/control
	@echo 'Depends: systemd'                       >> $(DESTDIR)/DEBIAN/control
	@echo 'Description: Tools for D-Link DNS-320L' >> $(DESTDIR)/DEBIAN/control

	editor $(DESTDIR)/DEBIAN/control
else
	@echo 'Found control file, just updating version and size field'
	@sed -e 's/^Version: .*/Version: $(VERSION)/g' -i $(DESTDIR)/DEBIAN/control
	@sed -e 's/^Installed-Size:: .*/Installed-Size: $(SIZE)/g' -i $(DESTDIR)/DEBIAN/control
endif

ifeq "$(wildcard $(DESTDIR)/DEBIAN/postinst)" ""
	@echo 'systemctl enable device_ready.service'    >  $(DESTDIR)/DEBIAN/postinst
	@echo 'systemctl enable device_poweroff.service' >> $(DESTDIR)/DEBIAN/postinst
	@chmod 755 $(DESTDIR)/DEBIAN/postinst
endif

ifeq "$(wildcard $(DESTDIR)/DEBIAN/prerm)" ""
	@echo 'systemctl disable device_ready.service'    >  $(DESTDIR)/DEBIAN/prerm
	@echo 'systemctl disable device_poweroff.service' >> $(DESTDIR)/DEBIAN/prerm
	@chmod 755 $(DESTDIR)/DEBIAN/prerm
endif

ifeq "$(wildcard $(DESTDIR)/DEBIAN/conffiles)" ""
	@echo '/etc/default/fancontrol'     >  $(DESTDIR)/DEBIAN/conffiles
endif

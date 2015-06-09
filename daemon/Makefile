
prefix   = /usr
DESTDIR  = ./DESTDIR
INSTALL  = install

bin_dir     = $(DESTDIR)/bin
etc_dir     = $(DESTDIR)/etc
systemd_dir = $(DESTDIR)/lib/systemd/system

.PHONY: all help install install_tools install_systemd_config

all:
	@echo "Nothing to build"

help:
	@echo 'Available targets:'
	@echo '  install                - Install scripts and systemd service files to $$DESTDIR'
	@echo '  install_tools          - Install scripts to $$DESTDIR'
	@echo '  install_systemd_config - Install systemd service files to $$DESTDIR'
	@echo ' '
	@echo 'The default value for $$DESTDIR is $(DESTDIR)'

install: install_tools install_systemd_config

install_tools:
	$(INSTALL) -d $(bin_dir)
	$(INSTALL) -m 0755 mcu/mcu_communicate.py   $(bin_dir)/mcu_communicate
	$(INSTALL) -m 0755 hddwatch/hddwatch.sh     $(bin_dir)/hddwatch
	$(INSTALL) -m 0755 fancontrol/fancontrol.sh $(bin_dir)/fancontrol
	$(INSTALL) -d $(etc_dir)/defaults
	$(INSTALL) fancontrol/fancontrol_defaults   $(etc_dir)/defaults/fancontrol

install_systemd_config:
	$(INSTALL) -d $(systemd_dir)
	$(INSTALL) hddwatch/hddwatch.service     $(systemd_dir)
	$(INSTALL) fancontrol/fancontrol.service $(systemd_dir)
	$(INSTALL) device_failure.service        $(systemd_dir)
	$(INSTALL) device_ready.service          $(systemd_dir)
	$(INSTALL) device_poweroff.service       $(systemd_dir)

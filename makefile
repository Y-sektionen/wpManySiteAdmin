PREFIX ?= /usr/local

BINARY_DIR ?= $(PREFIX)/bin/
SHARE_DIR ?= $(PREFIX)/share/wp-mass-admin
ETC_DIR ?= $(PREFIX)/etc
CRON_DIR ?= /etc/cron.d

.PHONY: uninstall install purge

install:
	# Main exec
	install -D $(CURDIR)/wpma $(BINARY_DIR)/wpma
	# Installer
	install -D $(CURDIR)/install/letsencrypt $(SHARE_DIR)/install/letsencrypt
	install -D $(CURDIR)/install/php5-fpm $(SHARE_DIR)/install/php5-fpm
	install -D $(CURDIR)/install/nginx $(SHARE_DIR)/install/nginx
	install -D $(CURDIR)/install/no-https $(SHARE_DIR)/install/no-https
	install -D $(CURDIR)/install/use-https $(SHARE_DIR)/install/use-https
	install -D $(CURDIR)/install/wp-site $(SHARE_DIR)/install/wp-site
	install -D $(CURDIR)/install/write-conf $(SHARE_DIR)/install/write-conf
	# Updater
	install -D $(CURDIR)/update/wp-site $(SHARE_DIR)/update/wp-site
	install -D $(CURDIR)/update/renew-https-certificates $(SHARE_DIR)/update/renew-https-certificates
	# Scanner
	cp -r $(CURDIR)/scan/ssllabs-scan $(SHARE_DIR)/scan/
	cp -r $(CURDIR)/scan/wpscan $(SHARE_DIR)/scan/
	install -D $(CURDIR)/scan/wp-site $(SHARE_DIR)/scan/wp-site
	# Deleter
	install -D $(CURDIR)/delete/wp-site $(SHARE_DIR)/delete/wp-site
	install -D $(CURDIR)/delete/write-conf $(SHARE_DIR)/delete/write-conf
	# Conf
	install -D -m 644 $(CURDIR)/common/conf.example $(PREFIX)/default/etc/wp-mass-admin/wpma.conf
	[ -s $(ETC_DIR)/wp-mass-admin/wpma.conf ] || install -D -m 644 $(CURDIR)/common/conf.example $(ETC_DIR)/wp-mass-admin/wpma.conf
	(echo PATH=/bin:/sbin:/usr/bin:$(BINARY_DIR); cat $(CURDIR)/common/crontab) > $(CRON_DIR)/wp-mass-admin
	mkdir -p /etc/nginx/includes
	install -D $(CURDIR)/common/nginx-include.conf /etc/nginx/includes/wpma-includes.conf
	# Letsencrypt files
	cp -r $(CURDIR)/letsencrypt $(SHARE_DIR)/

uninstall:
	rm -f $(BINARY_DIR)/wpma
	rm -rf $(SHARE_DIR)
	rm -f $(CRON_DIR)/wp-mass-admin
	rm -rf $(ETC_DIR)/default/wp-mass-admin

purge: uninstall
	rm -f $(ETC_DIR)/wp-mass-admin/wpma.conf


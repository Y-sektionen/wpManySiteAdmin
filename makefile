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
	install -D $(CURDIR)/install/wordpress-site $(SHARE_DIR)/install/wordpress-site
	# Updater
	install -D $(CURDIR)/update/wordpress-site $(SHARE_DIR)/update/wordpress-site
	install -D $(CURDIR)/update/renew-https-certificates $(SHARE_DIR)/update/renew-https-certificates
	# Scanner
	cp -r $(CURDIR)/scan/ssllabs-scan $(SHARE_DIR)/scan/
	cp -r $(CURDIR)/scan/wpscan $(SHARE_DIR)/scan/
	install -D $(CURDIR)/scan/wordpress-site $(SHARE_DIR)/scan/wordpress-site
	# Conf
	install -D -m 644 $(CURDIR)/conf.example $(ETC_DIR)/default/wp-mass-admin/wpma.conf
	[ -s $(ETC_DIR)/wp-mass-admin/wpma.conf ] || install -D -m 644 $(CURDIR)/conf.example $(ETC_DIR)/wp-mass-admin/wpma.conf
	(echo PATH=/bin:/sbin:/usr/bin:$(BINARY_DIR); cat crontab) > $(CRON_DIR)/wp-mass-admin
	# Letsencrypt files
	cp -r $(CURDIR)/letsencrypt $(SHARE_DIR)/

uninstall:
	rm -f $(BINARY_DIR)/wpma
	rm -rf $(SHARE_DIR)
	rm -f $(CRON_DIR)/wp-mass-admin
	rm -rf $(ETC_DIR)/default/wp-mass-admin

purge: uninstall
	rm -f $(ETC_DIR)/wp-mass-admin/wpma.conf


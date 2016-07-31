Wordpress Mass Administration
=============================

Scripts for simplified installation, maintenance, monitoring and deletion of Wordpress (WP) sites. Each site is after installation automatically upgraded through minor updates and scanned for vulnerabilities using wp-scan and ssl-labs-scan. Optionally sites can also be set up with HTTPS-certificates through Let's Encrypt or Active Directory support.


## License

```
Wordpress Mass Administration (wp-mass-admin) - Scripts for simplified
installation, maintenance and deletion of Wordpress sites.
Copyright (C) 2014 - 2016 CYD-poolen, Linköping University.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```


## Dependencies

These scripts depend on code from the following projects:

* php5-fpm
* nginx
* mysql
* go
* ruby
* wp-cli
* wp-scan
* letsencrypt

To install most dependencies on Debian Stable:

```bash
sudo apt-get install php5-cli php5-fpm nginx php5-ldap mysql-server php5-mysql ruby ruby-dev libcurl4-gnutls-dev make golang
```

### WP-cli

To install wp-cli from the project Github page (preferably using .deb-package), see their [installation page](http://wp-cli.org/docs/installing/).

```bash
sudo dpkg -i FILE.deb
```

## Installation

Clone this repository:

```bash
git clone --recursive https://github.com/CYD-poolen/wp-mass-admin
cd wp-mass-admin
sudo make install
```

### WP-scan

```bash
cd scan/wpscan
bundle install --without test --path vendor/bundle
```

### Let's encrypt

Run the letsencrypt-auto file in order for Let's encrypt to install its dependencies. 

```bash
cd ../../letsencrypt
./letsencrypt-auto
```


## Configuration

Edit the configuration file /usr/local/etc/wp-mass-admin/wpma.conf.

```bash
editor /usr/local/etc/wp-mass-admin/wpma.conf
```

```
# User info for admin user in WP-installs
admin_user=admin
admin_mail=admin@example.com

# Basepaths for WP-installs, WP is installed to $base_path/$user_name
base_path=/srv
```

## Installing a Wordpress site

Run wpma with username and fully qualified domain name (FQDN) as arguments. IMPORTANT! **The FQDN must be correctly configured and pointing to the host that's running the script if HTTPS is used.**

```bash
sudo wpma install USER FQDN
```

The script will output the MySQL and system password for your chosen user. It will also output a password for the Wordpress admin user chosen in the config file.



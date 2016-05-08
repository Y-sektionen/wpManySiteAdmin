Wordpress Mass Administration
=============================

Scripts for simplified installation, maintenance, monitoring and deletion of Wordpress (WP) sites. Each site is after installation automatically upgraded through minor updates and scanned for vulnerabilities using wp-scan and ssl-labs-scan. They're also set up with HTTPS-certificates through Let's Encrypt.

Note: The default installation installs the Active Directory (AD) plugin for Wordpress since AD is commonly used at LiU for user data. This readme does NOT cover AD-plugin configuration since that's specific to each domain.


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

Copy the example configuration file.

```bash
cd ..
cp conf.example conf
```

Enter your desired admin user name, admin user email and basepath for your WP-sites.

```bash
editor conf
```

```
# User info for admin user in WP-installs
adminUser=admin
adminMail=admin@example.com

# Basepaths for WP-installs, WP is installed to $basePath/$userName
basePath=/srv
```

### Scheduling maintenance scripts

Enter the cron table for the root account:

```bash
sudo crontab -e
```

Then add these lines to check for wordpress updates once a day, and renew https certificates once a month:

```crontab
min hour * * * /PATH/TO/PROJECT/DIR/update/wordpress
min hour 1 * * /PATH/TO/PROJECT/DIR/update/renew-https-certs
```


## Installing a Wordpress site

Run the script `install/wordpress-site` with username and fully qualified domain name (FQDN) as arguments. IMPORTANT! **The FQDN must be correctly configured and pointing to the host that's running the script.**

```bash
sudo ./install/wordpress-site USER FQDN
```

The script will output the MySQL and system password for your chosen user. It will also output a password for the Wordpress admin user chosen in the config file.

Add the USER for the site to the list of userNames in config file:

```
# Site name = user name that executes the site.
userNames="org1 org2"
```


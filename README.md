wpManySiteAdmin
===========

Scripts for simplified installation, update, monitoring and deletion of Wordpress sites. Each site is after installation automatically upgraded through minor updates and scanned for vulnerabilities using wp-scan and ssl-labs-scan.

Note: The default installation installs the Active Directory (AD) plugin for Wordpress since AD is commonly used at LiU for user data. This readme does NOT cover AD-plugin configuration since that's specific to each domain.

## License

```
CYD-poolen - wp-cli - Scripts for simplified installation, maintaining and
deletion of Wordpress sites. Copyright (C) 2014,2015 CYD-poolen, Linköping University.

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

## Installing requirements

These scripts are dependent on these components

* php5-fpm
* nginx
* mysql
* wp-cli
* go
* ruby

To install most dependencies on Debian Stable:

<pre>
sudo apt-get install php5-cli php5-fpm nginx php5-ldap mysql-server php5-mysql ruby ruby-dev libcurl4-gnutls-dev make golang
</pre>

**wp-cli**

Install wp-cli from the project Github page (preferable using .deb-package), https://github.com/wp-cli/wp-cli/wiki/Alternative-Install-Methods.

<pre>
sudo dpkg -i FILE.deb
</pre>

## Installation

Clone this repo:

<pre>
git clone --recursive https://github.com/CYD-poolen/wpManySiteAdmin
cd wpManySiteAdmin
</pre>

Complete the installation of wp-scan:

<pre>
cd scan/wpscan
bundle install --without test --path vendor/bundle
</pre>

**Let's encrypt**

Run the letsencrypt-auto file in order for Let's encrypt to install its dependencies. 

<pre>
cd letsencrypt
./letsencrypt-auto
</pre>

**Configuration**

Copy the example configuration file.

<pre>
cd ../..
cp conf.example conf
</pre>

Enter your desired admin user name, admin user email and basepath for your WP-sites.

<pre>
editor conf
</pre>

<pre>
# User info for admin user in WP-installs
adminUser=admin
adminMail=admin@example.com

# Basepaths for WP-installs, WP is installed to $basePath/$userName
basePath=/srv
</pre>

Add the update script to roots crontab:

<pre>
sudo crontab -e
</pre>

Add this line to check for update once a day:

<pre>
min hour * * * /PATH/TO/PROJECT/DIR/update/updateWP.bash
</pre>


## Installing a Wordpress site

Run the script installWP.bash with username and fully qualified domain name (FQDN) as arguments. IMPORTANT! The FQDN MUST BE CORRECTLY CONFIGURED AND POINTING TO THE HOST THAT'S RUNNING THE SCRIPT!

<pre>
sudo ./installWP.bash USER FQDN
</pre>

The script will output the MySQL and system password for your chosen user. It will also output a password for the Wordpress admin user chosen in the config file.

Add the username for the site to the list of userNames in config file:

<pre>
# Site name = user name that executes the site.
userNames="org1 org2"
</pre>


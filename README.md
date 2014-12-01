CYD-poolen - wp-cli
===========

Scripts for simplified installation, maintaining and ending/deletion of Wordpress sites. 

## License

```
CYD-poolen - wp-cli - Scripts for simplified installation, maintaining and ending/deletion of Wordpress sites. Copyright (C) 2014 CYD-poolen, Linköping University.

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

## Requirements

These scripts are dependent on these components

* php5-fpm
* nginx
* mysql
* wp-cli

Too install dependencies on Debian Stable: 

<pre>
sudo apt-get install php5-cli php5-fpm nginx php5-ldap mysql-server php5-mysql
</pre>

The init script for php5-fpm in Debian doesn't allow us to put sockets in the folder that you usually put it in (/var/run/php5-fpm), so we modify it. On line 14:

<pre>
socketdir=/var/run/php5-fpm
</pre>

Then on line 58 in the funciton do_start()

<pre>
# Create socket dir with correct permissions if it doesn't exist 
# since /run is cleaned on reboot /parker 2014-11-03
[ -d $socketdir ] || install -m 755 -o root -g root -d $socketdir
</pre>

Then install wp-cli from the projects Github page (preferable using .deb-package), https://github.com/wp-cli/wp-cli/wiki/Alternative-Install-Methods.

<pre>
sudo dpkg -i FILE.deb
</pre>

## Installing a Wordpress site

Run the script installWP.bash with username and FQDN as arguments:

<pre>
sudo ./installWP.bash USER FQDN
</pre>

The script will output the MySQL and system password for your chosen user. It will also output a password for the Wordpress admin user "cydadmin". 

## Updating your Wordpress sites

Add your users to the file update/updateWP.conf

<pre>
# Site name = username for the site
userNames="user1 user2"
</pre>

Add the update script to roots crontab

<pre>
sudo crontab -e
</pre>

Add this line:

<pre>
min hour * * * /PATH/TO/PROJECT/DIR/update/updateWP.bash
</pre>



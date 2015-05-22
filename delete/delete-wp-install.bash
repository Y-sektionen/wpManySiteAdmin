#!/bin/bash

if [[ $# != 2 || $S1 == "-h" || $S1 == "--help" ]]
then
	echo "Usage: "
	echo "	$0 userName FQDN"
	exit 1
fi

cd "$(dirname $0)"
# Read config file with paths to WP-installs and usernames
source ../conf


userName=$1
FQDN=$2

# Remove users and DBs
userdel $userName
groupdel $userName
echo "Please enter root password for MYSQL: "
mysql --user=root -p -e "drop database $userName;
drop user '$userName'@'localhost';"

# Remove configs
rm -f /etc/nginx/sites-enabled/$FQDN
rm -f /etc/nginx/sites-available/$FQDN
rm -f /etc/php5/fpm/pool.d/$FQDN.conf

# Remove WP-install
rm -rf $basePath/$userName
rm -rf /home/$userName/.wp-cli


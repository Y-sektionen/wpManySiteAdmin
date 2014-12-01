#!/bin/bash

if [[ $# != 2 || $S1 == "-h" || $S1 == "--help" ]]
then
	echo "Usage: "
	echo "	$0 userName FQDN"
	exit 1
fi

userName=$1
FQDN=$2

# Remove users and DBs
userdel $userName
mysql --user=root -p -e "drop database $userName;
drop user '$userName'@'localhost';"

# Remove configs
rm /etc/nginx/sites-enabled/$FQDN
rm /etc/nginx/sites-available/$FQDN
rm /etc/php5/fpm/pool.d/"$FQDN".conf

# Remove WP-install
rm -r /srv/$userName

#!/bin/bash

if [[ $# != 2 || $S1 == "-h" || $S1 == "--help" ]]
then
	echo "Usage: "
	echo "	$0 userName fullURL"
	exit 1
fi

userName=$1
fullURL=$2

# Remove users and DBs
userdel $userName
mysql --user=root -p -e "drop database $userName;
drop user '$userName'@'localhost';"

# Remove configs
rm /etc/nginx/sites-enabled/$fullURL
rm /etc/nginx/sites-available/$fullURL
rm /etc/php5/fpm/pool.d/"$fullURL".conf

# Remove WP-install
rm -r /srv/$userName



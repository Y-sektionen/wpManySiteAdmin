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


userName="$1"
FQDN="$2"
letsencryptFolder=/etc/letsencrypt

# Remove users and DBs
userdel "$userName"
groupdel "$userName"
echo "Please enter root password for MYSQL: "
mysql --user=root -p -e "drop database $userName;
drop user '$userName'@'localhost';"

# Remove configs
rm -f /etc/nginx/sites-enabled/"$FQDN"
rm -f /etc/nginx/sites-available/"$FQDN"
rm -f /etc/php5/fpm/pool.d/"$FQDN".conf

# Revoke certificate. Will try to revoke all certs. 
for certificate in $(ls $letsencryptFolder/archive/$FQDN | grep "cert"); do
	echo "Revoking cert $certificate"
	../letsencrypt/letsencrypt-auto revoke --cert-path "$letsencryptFolder"/archive/"$FQDN"/"$certificate"
	echo ""
done
# Remove config for domain
rm -f "$letsencryptFolder"/"$FQDN".cli.ini

# Remove WP-install
rm -rf "$basePath"/"$userName"
rm -rf /home/"$userName"/.wp-cli

systemctl reload nginx php5-fpm


#!/bin/bash

scriptDir="$(dirname $0)"
cd $scriptDir
# Read config file with paths to WP-installs and usernames
source ../conf

letsencFolder=/etc/letsencrypt

# Update all certs with cli.ini file in folder for Let's Encrypt
for configFile in $(ls $letsencFolder/*.cli.ini); do
	echo "Renewing cert using $configFile"
	../letsencrypt/letsencrypt-auto certonly --renew-by-default --config $configFile
	echo ""
done


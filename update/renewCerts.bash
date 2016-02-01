#!/bin/bash

scriptDir="$(dirname $0)"
cd $scriptDir
# Read config file with paths to WP-installs and usernames
source ../conf

letsencFolder=/etc/letsencrypt
dateNow=$(date -d "now" +%s)

if [ -z $expLimit ]
then
	echo "Expiry date not set in conf. See conf.example for example."
	exit 1
fi


# Update all certs with cli.ini file in folder for Let's Encrypt
for configFile in $(ls $letsencFolder/*.cli.ini); do
	
	primaryDomain=`grep "^\s*domains" $configFile | sed "s/^\s*domains\s*=\s*//" | sed 's/(\s*)\|,.*$//'`
	certFile=$letsencFolder/live/$primaryDomain/fullchain.pem
	expDate=$(date -d "`openssl x509 -in $certFile -text -noout | grep "Not After" | cut -c 25-`" +%s)
	expDays=$(echo \( $expDate - $dateNow \) / 86400 |bc)
	
	
	echo "-------"
	if [ "$expDays" -gt "$expLimit" ]
	then
		echo "The certificate for $primaryDomain is up to date, no need for renewal, $expDays days left."
	else
		echo "Renewing cert for $primaryDomain using $configFile"
		../letsencrypt/letsencrypt-auto certonly --renew-by-default --config $configFile
	fi
	
	echo ""
done

systemctl reload nginx


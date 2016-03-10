#!/bin/bash

if [[ $# != 2 || $S1 == "-h" || $S1 == "--help" ]]
then
        echo "Usage: "
        echo "  $0 userName FQDN"
        exit 1
fi

userName=$1
FQDN=$2
configFile=/etc/letsencrypt/"$FQDN".cli.ini

scriptDir="$(dirname $0)"
cd $scriptDir
# Read config file with paths to WP-installs and usernames
source ../conf

# Create configfolder+file if letsencrypt hasn't run yet
mkdir -p /etc/letsencrypt
touch $configFile

# Create a config file for domain
cat > $configFile << EOF
# Use a 4096 bit RSA key instead of 2048
rsa-key-size = 4096

# Uncomment and update to register with the specified e-mail address
email = $adminMail

# Uncomment and update to generate certificates for the specified
# domains.
domains = $FQDN

# Uncomment to use the webroot authenticator. Replace webroot-path with the
# path to the public_html / webroot folder being served by your web server.
authenticator = webroot
webroot-path = $basePath/$userName/wordpress

EOF

# There's a bug in the letsencrypt client which forces us to create some folders 
# for it in the webroot, and set root as owner, before we run the client. 
# https://community.letsencrypt.org/t/webroot-plugin-the-client-lacks-sufficient-authorization/5479/2
mkdir -p $basePath/$userName/wordpress/.well-known/acme-challenge
chown -R root $basePath/$userName/wordpress/.well-known

# Run letsencrypt and get cert
../letsencrypt/letsencrypt-auto certonly --renew-by-default --config $configFile



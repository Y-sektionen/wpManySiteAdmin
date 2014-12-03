#!/bin/bash
set -e

if [[ $# != 2 ]]
then
	echo "Usage: "
	echo "	$0 userName fullURLToSite"
	exit 1
fi

userName=$1
FQDN=$2
configFile=/etc/nginx/sites-available/$FQDN


# cd to script dir
scriptDir="$(dirname $0)"
cd $scriptDir
# Read config file with paths to WP-installs and usernames
source $scriptDir/../conf

# Create configfolder+file
mkdir -p /var/log/nginx/$FQDN
touch $configFile

cat > $configFile << EOF
server {
  server_name $FQDN *.$FQDN;

  error_log /var/log/nginx/$FQDN/error.log;
  access_log /var/log/nginx/$FQDN/access.log;

  root $basePath/$userName;

  index index.php index.html index.htm;

  location ~ \.php$ {
    try_files \$uri =404;
    fastcgi_pass unix:/var/run/php5-fpm/$FQDN.sock;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}

EOF

# Activate site
ln -s $configFile /etc/nginx/sites-enabled
service nginx reload

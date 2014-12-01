#!/bin/bash

if [[ $# != 2 ]]
then
	echo "Usage: "
	echo "	$0 userName fullURLToSite"
	exit 1
fi

userName=$1
fullURL=$2
configFile=/etc/nginx/sites-available/$fullURL

# Create configfolder+file
mkdir -p /var/log/nginx/$fullURL
touch $configFile

cat > $configFile << EOF
server {
  server_name $fullURL *.$fullURL;

  error_log /var/log/nginx/$fullURL/error.log;
  access_log /var/log/nginx/$fullURL/access.log;

  root /srv/$userName;

  index index.php index.html index.htm;

  location ~ \.php$ {
    try_files \$uri =404;
    fastcgi_pass unix:/var/run/php5-fpm/$fullURL.sock;
    fastcgi_index index.php;
    include fastcgi_params;
  }
}

EOF

# Activate site
ln -s $configFile /etc/nginx/sites-enabled
service nginx reload

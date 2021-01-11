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

scriptDir="$(dirname $0)"
cd $scriptDir
# Read config file with paths to WP-installs and usernames
source ../conf

# Create configfolder+file
mkdir -p /var/log/nginx/$FQDN
touch $configFile

# Initial conf for letsencrypt to work
cat > $configFile << EOF
server {
	listen 80;
	server_name $FQDN www.$FQDN;
	
	root $basePath/$userName/wordpress;
	
	location ~* .well-known* {
	autoindex on;
	}
	
	location / {
		rewrite ^ https://$FQDN;
	}
}

EOF

# If site is not enabled already, enable it
ln -sf $configFile /etc/nginx/sites-enabled
# Reload nginx so that letsencrypt can get cert
systemctl reload nginx

# Run letsencrypt to get cert
echo "Running letsencrypt to generate certificate for site!"
echo ""
./letsencrypt.bash $userName $FQDN

# SSL conf
cat >> $configFile << EOF
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;
	server_name $FQDN www.$FQDN;
	
	ssl_certificate /etc/letsencrypt/live/$FQDN/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$FQDN/privkey.pem;
	
	add_header Cache-Control "public";
	
	error_log /var/log/nginx/$FQDN/error.log;
	access_log /var/log/nginx/$FQDN/access.log;
	
	root $basePath/$userName/wordpress;
	index index.php index.html index.htm;
	client_max_body_size 50m;
	
	
	location = /favicon.ico {
		log_not_found off;
		access_log off;
	}
	
	# Allow robots to scan without flooding server
	location = /robots.txt {
		allow all;
		log_not_found off;
		access_log off;
	}
	
	# Deny access to any files with a .php extension in the uploads directory
	# Works in sub-directory installs and also in multisite network
	location ~* /(?:uploads|files)/.*\.php$ {
		deny all;
	}
	
	location ~ ~$ {
		deny all;
	}
	
	# End og restrictions -----------------
	
	location ~ \.php$ {
		try_files \$uri =404;
		fastcgi_pass unix:/srv/$userName/socket/php-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param	SCRIPT_FILENAME	\$document_root/\$fastcgi_script_name;
		include fastcgi_params;
	}
}

EOF

# Activate site
systemctl reload nginx.service

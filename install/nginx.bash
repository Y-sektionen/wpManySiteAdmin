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

cat > $configFile << EOF
server {
	server_name $FQDN *.$FQDN;

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

	# Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
	# Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
	location ~ /\. {
		deny all;
	}

	# Deny access to any files with a .php extension in the uploads directory
	# Works in sub-directory installs and also in multisite network
	location ~* /(?:uploads|files)/.*\.php$ {
		deny all;
	}
	# End og restrictions -----------------

	location ~ \.php$ {
		try_files \$uri =404;
		fastcgi_pass unix:/srv/$userName/socket/php-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}
}

EOF

# Activate site
ln -s $configFile /etc/nginx/sites-enabled
service nginx reload

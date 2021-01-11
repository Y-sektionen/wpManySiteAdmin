#!/bin/bash
set -e

if [[ $# != 2 ]]
then
	echo "Usage: "
	echo "	$0 userName"
	exit 1
fi

userName=$1
FQDN=$2
configFile=/etc/php/7.3/fpm/pool.d/$FQDN.conf

cd "$(dirname $0)"
# Read config file with paths to WP-installs and usernames
source ../conf

# Create conf for app pool
touch $configFile

cat > $configFile << EOF
[$FQDN]
prefix = $basePath/$userName
user = $userName
group = $userName
chroot = $prefix
chdir = wordpress

listen = socket/php-fpm.sock
listen.owner = $userName
listen.group = www-data
listen.mode = 770

pm = dynamic
pm.max_children = 4
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 4

EOF

# Activate app pool
systemctl restart php7.3-fpm.service

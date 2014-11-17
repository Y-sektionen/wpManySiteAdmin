#!/bin/bash

if [[ $# != 2 ]]
then
        echo "Usage: "
        echo "  $0 userName"
        exit 1
fi

userName=$1
fullURL=$2
configFile=/etc/php5/fpm/pool.d/$fullURL.conf

# Create conf for app pool
touch $configFile

cat > $configFile << EOF
[$fullURL]
user = $userName
group = $userName
listen = /srv/$fullURL/socket/$fullURL.sock
listen.owner = $userName
listen.group = www-data
listen.mode = 770
chroot = /srv/$fullURL/
chdir = /wordpress
pm = ondemand
pm.max_children = 4

EOF

# Activate app pool
service php5-fpm restart


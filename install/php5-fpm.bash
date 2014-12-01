#!/bin/bash

if [[ $# != 2 ]]
then
        echo "Usage: "
        echo "  $0 userName"
        exit 1
fi

userName=$1
FQDN=$2
configFile=/etc/php5/fpm/pool.d/$FQDN.conf

# Create conf for app pool
touch $configFile

cat > $configFile << EOF
[$FQDN]
prefix = /
user = $userName
group = $userName
listen = /var/run/php5-fpm/$FQDN.sock
listen.owner = $userName
listen.group = www-data
listen.mode = 770
chdir = $basePath/$userName
pm = ondemand
pm.max_children = 4

EOF

# Activate app pool
service php5-fpm restart

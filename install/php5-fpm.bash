#!/bin/bash

if [[ $# != 1 ]]
then
        echo "Usage: "
        echo "  $0 userName"
        exit 1
fi

userName=$1
configFile=/etc/php5/fpm/pool.d/$userName.conf

# Create conf for app pool
touch $configFile

cat > $configFile << EOF
[$userName]
user = $userName
group = $userName
listen = /var/run/php5-fpm/$userName.sock
listen.owner = $userName
listen.group = www-data
listen.mode = 770
; Jail app pool to content-dir
chroot = /srv/$userName/
pm = ondemand
pm.max_children = 4

EOF

# Activate app pool
ln -s $configFile /etc/uwsgi/apps-enabled/
service php5-fpm restart


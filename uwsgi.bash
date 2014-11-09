#!/bin/bash

if [[ $# != 1 ]]
then
        echo "Usage: "
        echo "  $0 userName"
        exit 1
fi

userName=$1
configFile=/etc/uwsgi/apps-available/$userName.ini

touch $configFile

cat > $configFile << EOF
[uwsgi]
plugin = php
uid = $userName
gid = $userName
chown-socket = $userName:www-data
chmod-socket = 770
processes = 1
threads = 4
project_dir=/srv/$userName

; chdir to proj dir
chdir = %(project_dir)

; jail our php environment to project_dir
php-docroot = %(project_dir)
; ... and to the .php and .inc extensions
php-allowed-ext = .php
php-allowed-ext = .inc
; and search for index.php and index.inc if required
php-index = index.php
php-index = index.inc
; set php timezone
php-set = date.timezone=Europe/Stockholm

EOF

ln -s $configFile /etc/uwsgi/apps-enabled/

service uwsgi restart


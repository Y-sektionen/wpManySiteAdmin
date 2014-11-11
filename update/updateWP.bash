#!/bin/bash

if [[ $# != 0 || $S1 == "-h" || $S1 == "--help" ]]
then
        echo "Usage: "
        echo "  $0"
        exit 1
fi

# cd to script dir
dir="$(dirname $0)"
cd $dir

# Read config file with paths to WP-installs and usernames
config=$dir/updateWP.conf
source $config

for userName in $userNames
do
	echo "Updating site for user $userName..."
	su - $userName -c "cd $basePath/$userName
wp core update
wp core update-db
wp plugin update --all"
	echo ""
done



#!/bin/bash
set -e

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
config=$dir/../conf
source $config

for userName in $userNames
do
    echo "Checking install $userName for minor update..."
    cd $basePath/$userName
    wp core check-update --allow-root | grep "minor"

    if [ $? == 0 ]
    then
        echo ""
        echo "Updating site for user $userName..."
        su - $userName -c "cd $basePath/$userName
wp core update --version=$(wp core check-update --allow-root | grep minor | awk {'print $1'})
wp core update-db"
    else
        echo "No minor update found for WP site $userName"
        wp core check-update --allow-root | grep "major"
        if [ $? == 0 ]
        then
            echo ""
            echo "MAJOR UPDATE AVAILABLE FOR $userName"
        fi
    fi

    # Update all plugins as well
    echo "Updating plugins for $userName"
    su - $userName -c "cd $basePath/$userName
wp plugin update --all"

	echo ""
done

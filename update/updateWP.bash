#!/bin/bash

if [[ $# != 0 || $S1 == "-h" || $S1 == "--help" ]]
then
		echo "Usage: "
		echo "  $0"
		exit 1
fi


cd "$(dirname $0)"
# Read config file with paths to WP-installs and usernames
source ../conf

for userName in $userNames
do
	echo "Checking install $userName for minor update..."
	cd $basePath/$userName/wordpress
	if wp core check-update --allow-root | grep "minor"	
	then
		echo ""
		echo "Updating site for user $userName..."
		su - $userName -c "cd $basePath/$userName/wordpress
wp core update --version=$(wp core check-update --allow-root | grep minor | awk {'print $1'})
wp core update-db"
	else
		echo "No minor update found for WP site $userName"
		if wp core check-update --allow-root | grep "major"
		then
			echo ""
			echo "MAJOR UPDATE AVAILABLE FOR $userName"
		fi
	fi

	# Update all plugins as well
	echo "Updating plugins for $userName"
	su - $userName -c "cd $basePath/$userName/wordpress
wp plugin update --all"
	
	
	# Update all plugins as well
	echo "Updating themes for $userName"
	su - $userName -c "cd $basePath/$userName/wordpress
wp theme update --all"
	
	echo ""
done


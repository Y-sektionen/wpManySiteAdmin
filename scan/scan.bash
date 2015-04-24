#!/bin/bash
cd "$(dirname $0)"
# Read config file with paths to WP-installs and usernames
source ../conf

# Update the git submodule(s) containing wpscan (and potentially other/future projects) so that we always run the latest version
git submodule foreach git pull origin master
# Set wpscan script
wpscan=./wpscan/wpscan.rb

sites = $(ls /etc/nginx/sites-enabled)

for site in sites
do
	echo "------------"
	echo "Scanning site $site for vulnerabilities using wpscan..."
	wpscan -u $site --follow-redirection -e u,vt,vp
	echo "------------"
	echo ""
done


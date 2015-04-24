WPScan
==============

Scripts using wpscan (https://github.com/wpscanteam/wpscan) to scan all sites hosted on the local machine. 

Installation
==============

First clone this repository, see README.md at the top level. 

Get the git sumodule for wpscan:

	git submodule update --init
	cd scan/wpscan

Install dependencies for wpscan:

	sudo apt-get install ruby ruby-dev libcurl4-gnutls-dev make
	sudo gem install bundler
	bundle install --without test --path vendor/bundle

Then either run the script scan.bash manually or add the script to your crontab. 


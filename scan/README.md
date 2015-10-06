Upstreams
=========

These scripts use [wpscan](https://github.com/wpscanteam/wpscan) to scan all sites hosted on the local machine.

They also make use of the SSL Labs [scan service](https://www.ssllabs.com/) and [scan script](https://github.com/ssllabs/ssllabs-scan).

Installation
==============

First clone this repository, see README.md at the top level.

Get the git sumodule for wpscan:

	git submodule update --init
	cd scan/wpscan

Install dependencies for wpscan:

	bundle install --without test --path vendor/bundle

Then either run the script ```scan``` manually or add the script to your crontab.

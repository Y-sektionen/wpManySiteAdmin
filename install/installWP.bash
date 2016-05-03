#!/bin/bash
set -e

if [[ $# != 2 || $S1 == "-h" || $S1 == "--help" ]]
then
	echo "Usage: "
	echo "	$0 userName fullURL"
	exit 1
fi

cd "$(dirname $0)"
# Read config file with paths to WP-installs and usernames
source ../conf

userName=$1
FQDN=$2
userPassword=$(echo -n $RANDOM | md5sum | awk {'print $1'})
wpAdminPassword=$(echo -n $RANDOM | md5sum | awk {'print $1'})
baseDir=$basePath/$userName
installDir=$baseDir/wordpress
socketDir=$baseDir/socket

# Create user in Linux and MySQL
useradd -p $(echo $userPassword | openssl passwd -1 -stdin) $userName

echo "Please enter root password for MYSQL"
mysql --user=root -p -e "create database $userName;
CREATE USER '$userName'@localhost IDENTIFIED BY '$userPassword';
GRANT ALL PRIVILEGES ON $userName . * TO '$userName'@'localhost';
UPDATE mysql.user SET max_user_connections=50 WHERE user='$userName' AND host='localhost';"
echo ""

# Create folders for WP. www-data in user group and correct permissions for server to run
mkdir -p $installDir
mkdir -p $socketDir
chown -R $userName:www-data $baseDir
chmod -R 750 $baseDir
chmod -R g+s $baseDir

echo "Installing Wordpress + AD-plugin"
# Install Wordpress + AD plugin using wp-cli
su - $userName -c "
cd $installDir
wp core download --locale=sv_SE
wp core config --dbname=$userName --dbuser=$userName --dbpass=$userPassword --locale=sv_SE
wp core install --url="https://$FQDN" --title='$userName website' --admin_user=$adminUser --admin_password=$wpAdminPassword --admin_email=$adminMail
wp plugin install active-directory-integration
wp plugin activate active-directory-integration"
echo ""

# Create config files for nginx and uwsgi
./nginx.bash $userName $FQDN
./php5-fpm.bash $userName $FQDN

echo ""
echo "This is the password for MySQL- and system user $userName:"
echo $userPassword
echo ""

echo "This is the password for WP-administrator-user $adminUser:"
echo $wpAdminPassword
echo ""


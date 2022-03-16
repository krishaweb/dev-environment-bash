#!/bin/bash

###################################################
# Bash script to install an LAMP stack in ubuntu OS
# Author: girishpanchal

# Check if running as root
if [ "$(id -u)" != "0" ]; then
 echo "This script must be run as root" 1>&2
 exit 1
fi

# Update packages and upgrade pending packages
echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt-get update -y && sudo apt-get upgrade -y

# Install apache2 packages.
echo -e "\n\nInstalling Apache2 Packages\n"
sudo apt-get install apache2 apache2-mpm-prefork -y
sudo ufw allow in "Apache" -y
sudo a2enmod rewrite
# sudo sed "$(grep -n "AllowOverride None" input.file |cut -f1 -d:)s/.*/AllowOverride All/" input.file > output.file

# Install MySQL database server
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"
sudo apt update
sudo apt-get install mysql-server mysql-client -y
sudo mysql_secure_installation -y

# Install PHP packages.
echo -e "\n\nInstalling PHP & Requirements\n"
sudo apt-get install php libapache2-mod-php php-mysql -y

## Install PhpMyAdmin
echo -e "\n\nInstalling phpmyadmin\n"
sudo apt update
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
sudo phpenmod mbstring
sudo systemctl restart apache2

## Configure PhpMyAdmin
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

echo -e "\n\nPermissions for /var/www\n"
sudo chown -R www-data:www-data /var/www
echo -e "\n\n Permissions have been set\n"
#!/bin/bash

###################################################
# Bash script to install an LAMP stack in ubuntu OS
# Author: girishpanchal

# Check whether you are running this as a root.
if [ "$(id -u)" != "0" ]; then
 echo "You have to run this script as a root user" 1>&2
 exit 1
fi

# Update packages and upgrade pending packages.
echo -e "\n\nUpdating apt packages and upgrading latest patches\n"
sudo apt update -y && sudo apt upgrade -y

# Install apache2 packages.
echo -e "\n\nInstalling Apache2 Packages\n"
sudo apt install apache2 -y
sudo ufw allow in "Apache Full"
# Allow 22 port to connect SSH
sudo ufw allow 'OpenSSH'
sudo a2enmod rewrite
sudo sed -i 's+DocumentRoot /var/www/html+DocumentRoot /var/www+g' /etc/apache2/sites-available/000-default.conf
sudo sed -z 's|<Directory /var/www/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None|<Directory /var/www/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All|' -i /etc/apache2/apache2.conf

# Install MySQL-8.0 database & mysql-server
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql.service

# Please use following command to set root password for the MYSQL.
# sudo mysql
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'Root@1234'; FLUSH PRIVILEGES; exit;"
# ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'Root@1234';
# flush privileges;
# exit;

# Install PHP packages.
echo -e "\n\nInstalling PHP & Requirements\n"
sudo apt update
sudo apt install php libapache2-mod-php php-mysql -y

# Install Multiple PHP versions.
# echo -e "\n\nInstalling PHP version 8.0 & 8.1\n"
# sudo apt update
# sudo apt install software-properties-common
# sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.1 php8.1-common libapache2-mod-php8.1 php8.1-intl php8.1-zip php8.1-curl php8.1-gd php8.1-gmp php8.1-pgsql php8.1-xml php8.1-dev php8.1-imap php8.1-mbstring php8.1-soap php8.1-mysql libapache2-mod-fcgid
# echo -e "\n\n Switching PHP version from 8.2 to 8.1"
# sudo a2dismod php8.2
# sudo a2enmod php8.1
# sudo systemctl restart apache2
# sudo update-alternatives --config php

Install Latest PhpMyAdmin
echo -e "\n\nInstalling phpmyadmin\n"
sudo apt update
sudo apt install phpmyadmin -y
sudo phpenmod mbstring
sudo systemctl restart apache2

## Configure PhpMyAdmin
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

# Install PhpMyAdmin v5.1.4
# echo -e "\n\nInstalling phpmyadmin\n"
# wget https://files.phpmyadmin.net/phpMyAdmin/5.1.4/phpMyAdmin-5.1.4-all-languages.zip
# unzip phpMyAdmin-5.1.4-all-languages.zip
# sudo mv phpMyAdmin-5.1.4-all-languages /usr/share/phpmyadmin
# # set the proper permissions
# sudo mkdir /usr/share/phpmyadmin/tmp
# sudo chown -R www-data:www-data /usr/share/phpmyadmin
# sudo chmod 777 /usr/share/phpmyadmin/tmp
# # sudo touch /etc/apache2/conf-available/phpmyadmin.conf
# echo "
# Alias /phpmyadmin /usr/share/phpmyadmin
# Alias /phpMyAdmin /usr/share/phpmyadmin
 
# <Directory /usr/share/phpmyadmin/>
#    AddDefaultCharset UTF-8
#    <IfModule mod_authz_core.c>
#       <RequireAny>
#       Require all granted
#      </RequireAny>
#    </IfModule>
# </Directory>
 
# <Directory /usr/share/phpmyadmin/setup/>
#    <IfModule mod_authz_core.c>
#      <RequireAny>
#        Require all granted
#      </RequireAny>
#    </IfModule>
# </Directory>" > phpmyadmin.conf
# sudo mv phpmyadmin.conf /etc/apache2/conf-available
# sudo a2enconf phpmyadmin
# sudo systemctl restart apache2

# Give a www-data ownership to www directory
# echo -e "\n\n Ownership for /var/www\n"
# sudo chown -R $(whoami):$(whoami) /var/www
# echo -e "\n\n Ownership have been set\n"

# Install Zip, Unzip, Git
echo -e "\n\nInstalling Git, Zip, and Unzip\n"
sudo apt update
sudo apt install zip unzip git

## Install MySql workbench.
# echo -e "\n\nInstalling workbench\n"
# sudo apt update
# sudo snap install mysql-workbench-community

# Install composer
echo -e "\n\nInstalling Composer\n"
sudo apt update
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
php -r "unlink('composer-setup.php');"

# Install nodejs-20 as a user
echo -e "\n\nInstalling nodejs 18\n"
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install nodejs -y
node -v
echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install docker 
echo -e "\n\nInstalling docker\n"
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
# sudo usermod -aG docker $(whoami)
# sudo chown "$(whoami)":"$(whoami)" /home/"$(whoami)"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

# Install VS code
echo -e "\n\nInstalling VS code\n"
sudo apt update
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code

# Install Sublime Text editor
echo -e "\n\nInstalling Sublime Text Editor\n"
sudo apt update
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt update
sudo apt install sublime-text

# Install FileZilla
echo -e "\n\nInstalling Sublime Text Editor\n"
sudo apt update
sudo apt install filezilla

# Install PHP_CodeSniffer
echo -e "\n\nInstalling PHP_CodeSniffer\n"
composer global require "squizlabs/php_codesniffer=*"
# first check if you already have composer's vendor bin directory as part of your path:
echo 'export PATH=$HOME/.config/composer/vendor/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
phpcs -i

# install_wpcli() {
#   curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#   php wp-cli.phar --info
#   chmod +x wp-cli.phar
#   sudo mv wp-cli.phar /usr/local/bin/wp
#   wp --info
#   echo "\e[1;42m WP CLI install successfully \e[0m"
# }

# while true; do

# read -p "Do you want to install WP CLI for WordPress (y/n) " yn

# case $yn in
#   [yY] )
#     install_wpcli
#     break;;
#   [nN] ) echo "\e[1;41m No \e[0m"
#     exit;;
# esac

# Install Dukto
echo -e "\n\nInstalling Dukto\n"
sudo add-apt-repository ppa:xuzhen666/dukto
sudo apt update
sudo apt install dukto

# Install Brave
echo -e "\n\nInstalling Brave\n"
sudo apt install apt-transport-https curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# done

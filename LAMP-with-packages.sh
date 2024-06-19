#!/bin/bash

###################################################
# Bash script to install an LAMP stack in ubuntu OS
# Author: girishpanchal

# Check whether you are running this as a root.
if [ "$(id -u)" != "0" ]; then
 echo "You have to run this script as a root user" 1>&2
 exit 1
fi

# Update and upgrade packages.
echo -e "\n\nUpdating and upgrading apt packages with latest patches\n"
sudo apt update -y && sudo apt upgrade -y
# Remove older or unused packages
sudo apt autoremove -y

# Install apache2 webserver.
echo -e "\n\nInstalling Apache2 webserver\n"
sudo apt install apache2 -y
sudo ufw allow 'Apache Full'
# Allow 22 port to connect SSH
sudo ufw allow 'OpenSSH'
sudo ufw allow ssh
sudo systemctl start apache2
sudo systemctl enable apache2
sudo a2enmod rewrite
sudo sed -i 's+DocumentRoot /var/www/html+DocumentRoot /var/www+g' /etc/apache2/sites-available/000-default.conf
sudo sed -z 's|<Directory /var/www/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None|<Directory /var/www/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All|' -i /etc/apache2/apache2.conf
# Update permission and ownership to www directory
sudo chown -R krish:krish /var/www/
sudo chmod -R 775 /var/www/

# Install MySQL-8.0.x database & mysql-server.
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql.service
# Please use following command to set root password for the MYSQL.
# sudo mysql
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Root@1234'; FLUSH PRIVILEGES; EXIT;"
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Root@1234';
# flush privileges;
# exit;

# Install PHP script.
echo -e "\n\nInstalling PHP & it's extension\n"
sudo apt update
sudo apt install php libapache2-mod-php php-mysql -y

# Install Multiple PHP versions.
# echo -e "\n\nInstalling PHP version 8.0 & 8.1\n"
# sudo apt update
# sudo apt install software-properties-common
# sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.1-common libapache2-mod-php8.1 php8.1-intl php8.1-zip php8.1-curl php8.1-gd php8.1-gmp php8.1-pgsql php8.1-xml php8.1-dev php8.1-imap php8.1-mbstring php8.1-soap php8.1-mysql libapache2-mod-fcgid -y
# echo -e "\n\n Switching PHP version from 8.2 to 8.1"
# sudo a2dismod php8.2
# sudo a2enmod php8.1
# sudo systemctl restart apache2
# sudo update-alternatives --config php

# Install phpMyAdmin interface.
echo -e "\n\nInstalling phpmyadmin panel\n"
sudo apt update && sudo apt upgrade -y
sudo apt install phpmyadmin -y
sudo phpenmod mbstring
sudo systemctl restart apache2
## Configure PhpMyAdmin
sudo bash -c 'echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf'

# Install ZIP, Unzip, git
echo -e "\n\nInstalling Git, ZIP, and Unzip\n"
sudo apt update
sudo apt install zip unzip git -y

## Install MySql workbench.
# echo -e "\n\nInstalling workbench\n"
# sudo apt update
# sudo snap install mysql-workbench-community

# Install composer
echo -e "\n\nInstalling Composer package\n"
sudo apt update
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
php -r "unlink('composer-setup.php');"

# Install nodejs through nvm
echo -e "\n\Installing nodejs through nvm\n"
sudo apt update
# Use curl or wget command
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source ~/.bashrc
nvm --version  # Check nvm version
nvm install node20  # Will install latest node and npm 
node -v  # Check node version

# Install docker 
echo -e "\n\nInstalling docker\n"
# Installing using the apt repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install the Docker packages.
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo groupadd docker
sudo chmod g+rwx "$HOME/.docker" -R

# Install PHP_CodeSniffer
echo -e "\n\nInstalling PHP_CodeSniffer\n"
composer global require "squizlabs/php_codesniffer=*"
# first check if you already have composer's vendor bin directory as part of your path:
echo 'export PATH=$HOME/.config/composer/vendor/bin:$PATH' >> ~/.bashrc
echo 'export PATH=$HOME/.composer/vendor/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
phpcs -i

# Install Dukto
echo -e "\n\nInstalling Dukto\n"
sudo add-apt-repository ppa:xuzhen666/dukto
sudo apt update
sudo apt install dukto -y

# Install Brave
echo -e "\n\nInstalling Brave Browser\n"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# Install VS code.
sudo apt install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
# Installing now.
sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders

# Install Sublime code.
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt install apt-transport-https
sudo apt update
sudo apt install sublime-text

# done

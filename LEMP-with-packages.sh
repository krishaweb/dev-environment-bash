#!/bin/bash

###################################################
# Bash script to install an LEMP stack in ubuntu OS
# Author: girishpanchal

# Check whether you are running this as a root.
if [ "$(id -u)" != "0" ]; then
 echo "You have to run this script as a root user" 1>&2
 exit 1
fi

# Update packages and upgrade pending packages.
echo -e "\n\nUpdating apt packages and upgrading latest patches\n"
sudo apt update -y && sudo apt upgrade -y

# Install NGINX packages.
echo -e "\n\nInstalling NGINX Packages\n"
sudo apt update
sudo apt install nginx
sudo ufw allow 'Nginx Full'
# Allow 22 port to connect SSH
sudo ufw allow 22

# Install MySQL-8.0.27 database & mysql-server
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql.service
# sudo mysql_secure_installation

# Please use following command to set root password for the MYSQL.
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'Root@1234'; FLUSH PRIVILEGES; exit;"
# ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'Root@1234';
# flush privileges;
# exit;

# Install PHP packages.
echo -e "\n\nInstalling PHP & Requirements\n"
sudo apt update
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.1 php8.1-fpm php8.1-mysql php-common php8.1-cli php8.1-common php8.1-opcache php8.1-readline php8.1-mbstring php8.1-xml php8.1-gd php8.1-curl -y
sudo systemctl start php8.1-fpm

# Install Latest PhpMyAdmin
echo -e "\n\nInstalling phpmyadmin\n"
sudo apt update
sudo apt install phpmyadmin -y
sudo phpenmod mbstring
sudo systemctl restart nginx

# Create server block for the nginx
sudo touch /etc/nginx/sites-available/my_site
echo "
server {
    listen 80;
    server_name your_domain www.your_domain;
    root /var/www/your_domain;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}" > my_site
sudo ln -s /etc/nginx/sites-available/my_site /etc/nginx/sites-enabled/
# Unlink default config
# sudo unlink /etc/nginx/sites-enabled/default
sudo systemctl reload nginx

# Install postgres database.
# sudo apt update
# sudo apt upgrade -y
# sudo apt install postgresql postgresql-client -y
# sudo systemctl enable postgresql.service
# sudo su -l postgres
# psql -c "alter user postgres with password 'Root@1234'";
# exit;
# sudo service postgresql restart

# Give a www-data ownership to www directory
# echo -e "\n\n Ownership for /var/www\n"
# sudo chown -R $(whoami):$(whoami) /var/www
# echo -e "\n\n Ownership have been set\n"

# Give a write permission to www directory
echo -e "\n\nPermissions for /var/www\n"
sudo chmod 777 /var/www
echo -e "\n\n Permissions have been set\n"

## Install MySql workbench.
# echo -e "\n\nInstalling workbench\n"
# sudo apt update
# sudo snap install mysql-workbench-community

# Install Zip, Unzip, Git
echo -e "\n\nInstalling Git, Zip, and Unzip\n"
sudo apt update
sudo apt install zip unzip git

# Install composer
echo -e "\n\nInstalling Composer\n"
sudo apt update
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
php -r "unlink('composer-setup.php');"

# Install nodejs-18 as a user
echo -e "\n\nInstalling nodejs 18\n"
sudo apt update
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
node -v
echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
# sudo chown -R $(whoami) /usr/local/lib/nodejs/bin/npm

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

# Install Sublime Text editor 3
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

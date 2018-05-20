#!/bin/sh

echo "------>>> Starting PHP  setup"
#Install PHP
yum -y install php

#Install PHP Modules
yum -y install php-json php-mbstring php-xml php-xmlrpc php-opcache php-mysqlnd php-gd

# Install Composer
if [ ! -f  /usr/local/bin/composer ]; then
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
else
  sudo /usr/local/bin/composer self-update
fi


#Restart Apache web server
service httpd restart

echo "------>>> END setting up PHP"

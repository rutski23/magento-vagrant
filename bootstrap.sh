#!/usr/bin/env bash

# This script can be used to perform any sort of command line actions to setup your box. 
# This includes installing software, importing databases, enabling new sites, pulling from 
# remote servers, etc. 

# update
echo "########################"
echo "##### UPDATING APT #####"
echo "########################"
apt-get update

# Install Apache
echo "#############################"
echo "##### INSTALLING APACHE #####"
echo "#############################"
apt-get -y install apache2

# Creating folder
echo "#######################################"
echo "##### magento FOLDER PERMISSIONS #####"
echo "#######################################"
chmod 0777 -R /var/www/html/magento

# enable modrewrite
echo "#######################################"
echo "##### ENABLING APACHE MOD-REWRITE #####"
echo "#######################################"
a2enmod rewrite 

# append AllowOverride to Apache Config File
echo "#######################################"
echo "##### CREATING APACHE CONFIG FILE #####"
echo "#######################################"
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/magento
		ServerName magento.dev
		ServerAlias www.magento.dev
		
		<Directory '/var/www/html/magento'>
			Options Indexes FollowSymLinks MultiViews
			AllowOverride All
			Order allow,deny
			allow from all
		</Directory>
</VirtualHost>
" > /etc/apache2/sites-available/magento.conf

echo "ServerName localhost" >> /etc/apache2/apache2.conf 

# Enabling Site
echo "##################################"
echo "##### Enabling magento Site #####"
echo "##################################"
a2ensite magento.conf

# Setting Locales
echo "###########################"
echo "##### Setting Locales #####"
echo "###########################"
locale-gen en_US en_US.UTF-8 pl_PL pl_PL.UTF-8
dpkg-reconfigure locales

# Install MySQL 5.6
echo "############################"
echo "##### INSTALLING MYSQL #####"
echo "############################"
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server-5.6 mysql-client-5.6

# Create Database instance
echo "#############################"
echo "##### CREATING DATABASE #####"
echo "#############################"
mysql -u root -e "create database magento;"

# Install PHP 5.5
echo "##########################"
echo "##### INSTALLING PHP #####"
echo "##########################"
apt-get -y install php5

# Install Required PHP extensions
echo "#####################################"
echo "##### INSTALLING PHP EXTENSIONS #####"
echo "#####################################"
apt-get -y install php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-common php-pear php5-dev php5-xsl

# Mcrypt issue
echo "#############################"
echo "##### PHP MYCRYPT PATCH #####"
echo "#############################"
php5enmod mcrypt
service apache2 restart

# Set PHP Timezone
echo "########################"
echo "##### PHP TIMEZONE #####"
echo "########################"
echo "date.timezone = America/New_York" >> /etc/php5/cli/php.ini

# Set Pecl php_ini location
echo "##########################"
echo "##### CONFIGURE PECL #####"
echo "##########################"
pear config-set php_ini /etc/php5/apache2/php.ini

# Install Xdebug
echo "##########################"
echo "##### INSTALL XDEBUG #####"
echo "##########################"
pecl install xdebug

# Install Pecl Config variables
echo "############################"
echo "##### CONFIGURE XDEBUG #####"
echo "############################"
echo "xdebug.remote_enable = 1" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php5/apache2/php.ini

# Install Magerun
echo "###########################"
echo "##### INSTALL MAGERUN #####"
echo "###########################"
wget http://files.magerun.net/n98-magerun-latest.phar -O n98-magerun.phar
chmod +x ./n98-magerun.phar
mv ./n98-magerun.phar /usr/local/bin/magerun

# Restart apache
echo "#############################"
echo "##### RESTARTING APACHE #####"
echo "#############################"
service apache2 restart

# Post Up Message
echo "magento Vagrant Box ready!"
echo "Go to http://192.168.33.10/magento/setup/ to finish installation."
echo "If you configured your hosts file, go to http://www.magento.dev/setup/"

#!/bin/sh
echo "------>>> Starting Database setup"

USERNAME="$1"
PASSWORD="$2"
DATABASE="$4"
CURRENT_ROOT_PASSWORD=''
NEW_ROOT_PASSWORD="$3"

#Install MariaDB Server

yum -y install mariadb-server
sudo service mariadb start
sudo systemctl enable mariadb

#Secure MySQL installation

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"$CURRENT_MYSQL_PASSWORD\r\"

expect \"Change the root password?\"
send \"y\r\"

expect \"New password:\"
send \"$NEW_ROOT_PASSWORD\r\"

expect \"Re-enter new password:\"
send \"$NEW_ROOT_PASSWORD\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"


#Create database and add premissions
mysql --user="root" --password="$NEW_ROOT_PASSWORD" -e "CREATE USER '$1'@'0.0.0.0' IDENTIFIED BY '$2';"
mysql --user="root" --password="$NEW_ROOT_PASSWORD" -e "CREATE DATABASE $4 DEFAULT CHARACTER SET 'utf8';"
mysql --user="root" --password="$NEW_ROOT_PASSWORD" -e "GRANT ALL ON *.* TO '$1'@'0.0.0.0' IDENTIFIED BY '$2' WITH GRANT OPTION;"
mysql --user="root" --password="$NEW_ROOT_PASSWORD" -e "GRANT ALL ON *.* TO '$1'@'%' IDENTIFIED BY '$2' WITH GRANT OPTION;"
mysql --user="root" --password="$NEW_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

service mariadb restart

echo ">>> End setting up database"

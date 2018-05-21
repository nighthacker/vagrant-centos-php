#!/bin/sh
echo "      ================================================================================"
echo ">>>>>>>>>>>>>> Starting Webserver setup"

#Install Apache Http Server
yum -y install httpd
service httpd start

#Add Apache server to start
chkconfig httpd on
systemctl enable httpd

#Create required directories: sites-available & sites-enabled, etc
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled

#Create public html directory
#su - vagrant -c "mkdir /home/vagrant/public_html"
#su - vagrant -c "touch /home/vagrant/public_html/index.php"
find /vagrant -type d -exec chmod 755 {} \;
find /vagrant -type f -exec chmod 644 {} \;

# Add enabled sites to configuration
echo 'IncludeOptional sites-enabled/*.conf' >> /etc/httpd/conf/httpd.conf

# Zamienia pierwsze wystapienie www-data na vagrant w pliku /etc/apache2/envvars
#sed -i "s/www-data/vagrant/" /etc/apache2/envvars

# Setting ServerName from httpd.conf file
#sed -i "s|#ServerName www.example.com:80|ServerName 127.0.0.1:80"
#sed -i '\|#ServerName www.example.com:80| {N;s|\n$|\nServerName 127.0.0.1:80|}' /etc/httpd/conf/httpd.conf
sed -i '/#ServerName www.example.com:80/a ServerName 127.0.0.1:80' /etc/httpd/conf/httpd.conf

#Create VirtualHost
declare -A params=$4     # Create an associative array
paramsTXT=""
if [ -n "$4" ]; then
    for element in "${!params[@]}"
    do
        paramsTXT="${paramsTXT}
        SetEnv ${element} \"${params[$element]}\""
    done
fi

block="<VirtualHost *:$3>
    # The ServerName directive sets the request scheme, hostname and port that
    # the server uses to identify itself. This is used when creating
    # redirection URLs. In the context of virtual hosts, the ServerName
    # specifies what hostname must appear in the request's Host: header to
    # match this virtual host. For the default virtual host (this file) this
    # value is not decisive as it is used as a last resort host regardless.
    # However, you must set it for any further virtual host explicitly.
    #ServerName www.example.com
    ServerAdmin webmaster@localhost
    ServerName $1
    ServerAlias www.$1
    DocumentRoot "$2"
    $paramsTXT
    <Directory "$2">
        AllowOverride All
        Require all granted
    </Directory>
    # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
    # error, crit, alert, emerg.
    # It is also possible to configure the loglevel for particular
    # modules, e.g.
    #LogLevel info ssl:warn
    ErrorLog /var/log/httpd/$1-error.log
    CustomLog /var/log/httpd/$1-access.log combined
    # For most configuration files from conf-available/, which are
    # enabled or disabled at a global level, it is possible to
    # include a line for only one particular virtual host. For example the
    # following line enables the CGI configuration for this host only
    # after it has been globally disabled with "a2disconf".
    #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
"

echo "$block" > "/etc/httpd/sites-available/$1.conf"
ln -fs "/etc/httpd/sites-available/$1.conf" "/etc/httpd/sites-enabled/$1.conf"


#chown -R apache:apache /var/www/html/laravel
#chmod -R 755 /var/www/html/laravel/storage



#Restart Apache web server
service httpd restart

echo "------>>> End setting up Webserver"

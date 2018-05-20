#!/bin/sh

echo "------>>> Starting General Environment setup (system tools, repositories, etc.)"

#Disable SELINUX
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/conf
setenforce 0

#Install required repository with nginx
#yum clean all
#yum -y update

#Install expect
yum -y install expect

#Install wget
yum -y install wget

#Install Lynx web browser
yum -y install lynx

#Install YUM Utils
yum -y install yum-utils

yum -y groupinstall "Development Tools"
yum -y install kernel-devel
yum -y install dkms

#Install EPEL Repository
yum -y install epel-release

#Install REMI repository
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

#Enable REMI repo
yum-config-manager --enable remi-php72
yum -y update

echo "------>>> END setting up environmental tools and repositories"

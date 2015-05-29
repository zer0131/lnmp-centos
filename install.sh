#!/bin/sh


###---安装环境---##
./install_env.sh

###---安装mysql-5.6.24---##
./install_mysql.sh

###---安装nginx-1.7.2---##
./install_nginx.sh

###---安装php-5.5.25---##
./install_php.sh

echo "----安装完成----" >> tmp.log

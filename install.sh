#!/bin/sh


###---安装环境---##
./env.sh

###---安装mysql-5.6.24---##
./mysql.sh

###---安装nginx-1.7.2---##
./nginx.sh

###---安装php-5.5.25---##
./php.sh

echo "----安装完成----" >> tmp.log

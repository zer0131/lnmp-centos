#!/bin/bash


rm -rf nginx-1.7.6
mkdir -p /usr/local/nginx

###---创建wwww用户组和用户---begin###
groupadd www
useradd -g www  -s /sbin/nologin www
echo "----创建wwww用户组和用户完成----" >> tmp.log
###---创建wwww用户组和用户---end###

tar -zxvf ./pkg/nginx-1.7.6.tar.gz
cd nginx-1.7.6
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --without-http-cache --with-http_ssl_module --with-http_gzip_static_module
make
make install
cd ..
chmod 775 /usr/local/nginx/logs
chown -R www:www /usr/local/nginx/logs

cp -fR ./nginx_config/* /usr/local/nginx/conf/
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i 's/worker_processes  1/worker_processes  '"$CPU_NUM"'/' /usr/local/nginx/conf/nginx.conf
chmod 755 /usr/local/nginx/sbin/nginx

mv /usr/local/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

ln -s /usr/local/nginx/sbin/* /usr/local/bin/

/etc/init.d/nginx start

echo "----nginx安装完成----" >> tmp.log
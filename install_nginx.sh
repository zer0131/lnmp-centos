#!/bin/bash


rm -rf nginx-1.7.6
mkdir -p /home/ryan/opt/nginx

###---创建wwww用户组和用户---begin###
groupadd www
useradd -g www  -s /sbin/nologin www
echo "----创建wwww用户组和用户完成----" >> tmp.log
###---创建wwww用户组和用户---end###

tar -zxvf ./pkg/nginx-1.7.6.tar.gz
cd nginx-1.7.6
./configure --user=www --group=www --prefix=/home/ryan/opt/nginx --with-http_stub_status_module --without-http-cache --with-http_ssl_module --with-http_gzip_static_module
make
make install
cd ..
chmod 775 /home/ryan/opt/nginx/logs
chown -R www:www /home/ryan/opt/nginx/logs

cp -fR ./nginx_config/* /home/ryan/opt/nginx/conf/
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i 's/worker_processes  1/worker_processes  '"$CPU_NUM"'/' /home/ryan/opt/nginx/conf/nginx.conf
chmod 755 /home/ryan/opt/nginx/sbin/nginx

mv /home/ryan/opt/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

ln -s /home/ryan/opt/nginx/sbin/* /usr/local/bin/

/etc/init.d/nginx start

echo "----nginx安装完成----" >> tmp.log
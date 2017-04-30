#!/bin/bash

nginxVersion="1.7.6"
nginxPath="~/opt/nginx-${nginxVersion}"

if [! -e "nginx-${nginxVersion}.tar.gz"];then
    wget http://7xkyq4.com1.z0.glb.clouddn.com/nginx/nginx-${nginxVersion}.tar.gz
fi
rm -rf nginx-${nginxVersion}
mkdir -p ${nginxPath}

###---创建wwww用户组和用户---begin###
groupadd www
useradd -g www  -s /sbin/nologin www
echo "----创建wwww用户组和用户完成----" >> tmp.log
###---创建wwww用户组和用户---end###

tar -xf nginx-${nginxVersion}.tar.gz
cd nginx-${nginxVersion}
./configure --user=www --group=www --prefix=${nginxPath} --with-http_stub_status_module --without-http-cache --with-http_ssl_module --with-http_gzip_static_module
make
make install
cd ..
chmod 775 ${nginxPath}/logs
chown -R www:www ${nginxPath}/logs

cp -fR ./nginx_config/* ${nginxPath}/conf/
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i 's/worker_processes  1/worker_processes  '"$CPU_NUM"'/' ${nginxPath}/conf/nginx.conf
chmod 755 ${nginxPath}/sbin/nginx

mv ${nginxPath}/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

ln -s ${nginxPath}/sbin/* /usr/local/bin/

#/etc/init.d/nginx start

echo "----nginx安装完成----" >> tmp.log

#!/bin/bash

phpVersion="5.5.25"
phpPath="/home/ryan/opt/php-${phpVersion}"

if [! -e "php-${phpVersion}.tar.gz"];then
    wget http://7xkyq4.com1.z0.glb.clouddn.com/php/php-${phpVersion}.tar.gz
fi
rm -rf php-${phpVersion}

tar -xf php-${phpVersion}.tar.gz
cd php-${phpVersion}
./configure --prefix=${phpPath} --enable-opcache --with-config-file-path=${phpPath}/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-fpm --enable-fastcgi --enable-static --enable-inline-optimization --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-bcmath --enable-soap --with-zlib --with-iconv --with-gd --with-xmlrpc --enable-mbstring --without-sqlite --with-curl --enable-ftp --with-mcrypt  --with-freetype-dir=/usr/local/freetype.2.1.10 --with-jpeg-dir=/usr/local/jpeg.6 --with-png-dir=/usr/local/libpng.1.2.50 --disable-ipv6 --disable-debug --with-openssl --disable-maintainer-zts --disable-safe-mode --disable-fileinfo

make ZEND_EXTRA_LIBS='-liconv'
make install
cd ..

cp ./php-${phpVersion}/php.ini-production ${phpPath}/etc/php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "'"${phpPath}"'/lib/php/extensions/no-debug-non-zts-20121212/"#'  ${phpPath}/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' ${phpPath}/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' ${phpPath}/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' ${phpPath}/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' ${phpPath}/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' ${phpPath}/etc/php.ini

cp ${phpPath}/etc/php-fpm.conf.default ${phpPath}/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = '"${phpPath}"'/var/log/php-fpm.log,g'   ${phpPath}/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = '"${phpPath}"'/var/log/\$pool.log.slow,g'   ${phpPath}/etc/php-fpm.conf

install -v -m755 ./php-${phpVersion}/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm

ln -s ${phpPath}/sbin/* /usr/local/bin/
ln -s ${phpPath}/bin/* /usr/local/bin/

#/etc/init.d/php-fpm start

echo "----安装php完成----" >> tmp.log

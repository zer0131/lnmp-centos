#!/bin/bash


rm -rf php-5.5.25

tar -zxvf ./pkg/php-5.5.25.tar.gz
cd php-5.5.25
./configure --prefix=/usr/local/php55 --enable-opcache --with-config-file-path=/usr/local/php55/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-fpm --enable-fastcgi --enable-static --enable-inline-optimization --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-bcmath --enable-soap --with-zlib --with-iconv --with-gd --with-xmlrpc --enable-mbstring --without-sqlite --with-curl --enable-ftp --with-mcrypt  --with-freetype-dir=/usr/local/freetype.2.1.10 --with-jpeg-dir=/usr/local/jpeg.6 --with-png-dir=/usr/local/libpng.1.2.50 --disable-ipv6 --disable-debug --with-openssl --disable-maintainer-zts --disable-safe-mode --disable-fileinfo

make ZEND_EXTRA_LIBS='-liconv'
make install
cd ..

cp ./php-5.5.25/php.ini-production /usr/local/php55/etc/php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/usr/local/php55/lib/php/extensions/no-debug-non-zts-20121212/"#'  /usr/local/php55/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /usr/local/php55/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /usr/local/php55/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /usr/local/php55/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /usr/local/php55/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/php55/etc/php.ini

cp /usr/local/php55/etc/php-fpm.conf.default /usr/local/php55/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = /usr/local/php55/var/log/php-fpm.log,g'   /usr/local/php55/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = /usr/local/php55/var/log/\$pool.log.slow,g'   /usr/local/php55/etc/php-fpm.conf

install -v -m755 ./php-5.5.25/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm

ln -s /usr/local/php55/sbin/* /usr/local/bin/
ln -s /usr/local/php55/bin/* /usr/local/bin/

/etc/init.d/php-fpm start

echo "----安装php完成----" >> tmp.log

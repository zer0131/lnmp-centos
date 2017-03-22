#!/bin/sh


###---安装依赖包---begin###
yum makecache
yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel automake libaio*
iptables -F
echo "----依赖包安装完毕----" >> tmp.log
###---安装依赖包---end###

###---创建安装目录---###
mkdir -p /home/ryan/opt

###---安装所需的库---begin###
wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/libiconv-1.13.1.tar.gz
rm -rf libiconv-1.13.1
tar -zxvf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local
make
make install
cd ..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/zlib-1.2.3.tar.gz
rm -rf zlib-1.2.3
tar -zxvf zlib-1.2.3.tar.gz
cd zlib-1.2.3
./configure
make CFLAGS=-fpic
make install
cd ..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/freetype-2.1.10.tar.gz
rm -rf freetype-2.1.10
tar -zxvf freetype-2.1.10.tar.gz
cd freetype-2.1.10
./configure --prefix=/usr/local/freetype.2.1.10
make
make install
cd ..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/libpng-1.2.50.tar.gz
rm -rf libpng-1.2.50
tar -zxvf libpng-1.2.50.tar.gz
cd libpng-1.2.50
./configure --prefix=/usr/local/libpng.1.2.50
make CFLAGS=-fpic
make install
cd ..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/libevent-1.4.14b-stable.tar.gz
rm -rf libevent-1.4.14b-stable
tar -zxvf libevent-1.4.14b-stable.tar.gz
cd libevent-1.4.14b-stable
./configure
make
make install
cd ..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/libmcrypt-2.5.8.tar.gz
rm -rf libmcrypt-2.5.8
tar -zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --disable-posix-threads
make
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/pcre-8.12.tar.gz
rm -rf pcre-8.12
tar -zxvf pcre-8.12.tar.gz
cd pcre-8.12
./configure
make
make install
cd ..

wget http://7xkyq4.com1.z0.glb.clouddn.com/linux/jpegsrc.v6b.tar.gz
rm -rf jpeg-6b
tar -zxvf jpegsrc.v6b.tar.gz
cd jpeg-6b
if [ -e /usr/share/libtool/config.guess ]
then 
	cp -f /usr/share/libtool/config.guess .
elif [ -e /usr/share/libtool/config/config.guess ]
then
	cp -f /usr/share/libtool/config/config.guess .
fi
if [ -e /usr/share/libtool/config.sub ]
then
	cp -f /usr/share/libtool/config.sub .
elif [ -e /usr/share/libtool/config/config.sub ]
then
	cp -f /usr/share/libtool/config/config.sub .
fi
./configure --prefix=/usr/local/jpeg.6 --enable-shared --enable-static
mkdir -p /usr/local/jpeg.6/include
mkdir /usr/local/jpeg.6/lib
mkdir /usr/local/jpeg.6/bin
mkdir -p /usr/local/jpeg.6/man/man1
make
make install-lib
make install
cd ..

echo "----安装库完毕----" >> tmp.log
###---安装所需的库---end###

#load /usr/local/lib .so
touch /etc/ld.so.conf.d/usrlib.conf
echo "/usr/local/lib" > /etc/ld.so.conf.d/usrlib.conf
/sbin/ldconfig
echo "----加载自定义库完成----" >> tmp.log


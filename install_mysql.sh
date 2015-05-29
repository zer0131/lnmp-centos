#!/bin/sh


rm -rf mysql-5.6.24-linux-glibc2.5-x86_64

mkdir -p /usr/local/mysql

###---创建mysql用户组及用户---begin###
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
echo "----创建mysql用户组及用户完成----" >> tmp.log
###---创建mysql用户组及用户---end###

tar -zxvf ./pkg/mysql-5.6.24-linux-glibc2.5-x86_64.tar.gz
mv mysql-5.6.24-linux-glibc2.5-x86_64/* /usr/local/mysql

/usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

chown -R mysql:mysql /usr/local/mysql/
chown -R mysql:mysql /usr/local/mysql/data/

\cp -f /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/usr/local/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/usr/local/mysql/data#' /etc/init.d/mysqld

cat > /etc/my.cnf <<END
[client]
port            = 3306
socket          = /tmp/mysql.sock
[mysqld]
port            = 3306
socket          = /tmp/mysql.sock
skip-external-locking
#log-error=
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M

log-bin=mysql-bin
binlog_format=mixed
server-id       = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
END

chmod 755 /etc/init.d/mysqld

ln -s /usr/local/mysql/bin/* /usr/local/bin/

/etc/init.d/mysqld start

#mysqladmin -u root password 'password'

echo "----mysql安装完成----" >> tmp.log

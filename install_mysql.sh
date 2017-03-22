#!/bin/sh

mysqlVersion="5.6.24"
mysqlPath="/home/ryan/opt/mysql-${mysqlVersion}"

wget http://7xkyq4.com1.z0.glb.clouddn.com/mysql/mysql-${mysqlVersion}-linux-glibc2.5-x86_64.tar.gz
rm -rf mysql-${mysqlVersion}-linux-glibc2.5-x86_64

mkdir -p ${mysqlPath}

###---创建mysql用户组及用户---begin###
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
echo "----创建mysql用户组及用户完成----" >> tmp.log
###---创建mysql用户组及用户---end###

tar -zxvf mysql-${mysqlVersion}-linux-glibc2.5-x86_64.tar.gz
mv mysql-${mysqlVersion}-linux-glibc2.5-x86_64/* ${mysqlPath}

${mysqlPath}/scripts/mysql_install_db --user=mysql --basedir=${mysqlPath} --datadir=${mysqlPath}/data

chown -R mysql:mysql ${mysqlPath}/
chown -R mysql:mysql ${mysqlPath}/data/

cp -f ${mysqlPath}/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir='"${mysqlPath}"'#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir='"${mysqlPath}"'/data#' /etc/init.d/mysqld

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

ln -s ${mysqlPath}/bin/* /usr/local/bin/

#/etc/init.d/mysqld start

#mysqladmin -u root password 'password'

echo "----mysql安装完成----" >> tmp.log

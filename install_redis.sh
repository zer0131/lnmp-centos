#!/bin/sh

tar -xf redis-3.0.4.tar.gz
cd redis-3.0.4.tar.gz
make && make test
make PREFIX=/home/ryan/opt/redis install
mkdir /home/ryan/opt/redis/conf
cp redis_config/redis.conf /home/ryan/opt/redis/conf/
mkdir /home/ryan/opt/redis/data
mkdir /home/ryan/opt/redis/log


cp redis_config/redis_6380 /etc/init.d/
cp redis_config/6380.conf /home/ryan/opt/redis/conf/
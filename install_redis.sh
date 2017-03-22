#!/bin/sh

redisVersion="3.0.4"
redisPath="/home/ryan/opt/redis-${redisVersion}"

wget http://7xkyq4.com1.z0.glb.clouddn.com/redis/redis-${redisVersion}.tar.gz
tar -xf redis-${redisVersion}.tar.gz
cd redis-${redisVersion}
make && make test
make PREFIX=${redisPath} install
cd ..

mkdir ${redisPath}/conf
cp redis_config/redis.conf ${redisPath}/conf/
mkdir ${redisPath}/data
mkdir ${redisPath}/log


cp redis_config/redis_6380 /etc/init.d/
cp redis_config/6380.conf ${redisPath}/conf/

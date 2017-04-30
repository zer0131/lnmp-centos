#!/bin/sh

redisVersion="3.0.4"
redisPath="~/opt/redis-${redisVersion}"

if [! -e "redis-${redisVersion}.tar.gz"];then
    wget http://7xkyq4.com1.z0.glb.clouddn.com/redis/redis-${redisVersion}.tar.gz
fi
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

#!/bin/bash
date=`date '+%F %T'`
echo "当前时间:"${date}

pid=($(ps -ef | grep redis-server | grep -v grep | awk '{print $2}'))
for a in ${pid[*]}
do
    echo "Redis已启动，杀死原进程:"${a}
    kill -9 ${a}
done

sleep 1
#启动master
/home/docker/redis/src/redis-server /home/docker/redis/redis.conf
#启动哨兵
/home/docker/sentinel/src/redis-server /home/docker/sentinel/sentinel.conf --sentinel
sleep 1

pid2=($(ps -ef | grep redis-server | grep -v grep | awk '{print $2}'))
for b in ${pid2[*]}
do
    echo "Redis已启动，进程:"${b}
done

exit 0
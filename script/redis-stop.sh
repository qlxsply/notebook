#!/bin/bash
date=`date '+%F %T'`
echo "当前时间:"${date}

pid=($(ps -ef | grep redis-server | grep -v grep | awk '{print $2}'))
for a in ${pid[*]}
do
    echo "Redis已启动，杀死原进程:"${a}
    kill -9 ${a}
done

exit 0
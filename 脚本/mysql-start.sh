#!/bin/bash

date=`date '+%F %T'`
echo "当前时间:"${date}

pid=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
if [ $pid ];then
    echo "MySQL已启动，进程:"${pid}
else
    echo "MySQL未启动，准备启动..."
    /home/avalon/mysql/bin/mysqld --defaults-file=/home/avalon/mysql/my.cnf --user=avalon >/dev/null 2>&1 & 
    sleep 1
    pid2=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
    if [ ${pid2} ];then
        echo "MySQL启动成功，进程:"${pid2}
        exit 0
    else
        echo "MySQL启动失败！"
    fi
fi

exit 0
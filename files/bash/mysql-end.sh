#!/bin/bash

date=`date '+%F %T'`
echo "当前时间:"${date}

pid=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
if [ $pid ];then
    echo "MySQL当前进程:${pid}，准备关闭MySQL应用。"
    expect /home/avalon/bash/shutdown.exp
    oid=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
    if [ $oid ];then
        echo "MySQL关闭失败，进程${oid}依然存在。"
    else
        echo "MySQL关闭成功！"
    fi
else
    echo "当前没有MySQL进程存在！"
fi

#!/bin/bash

date=`date '+%F %T'`
echo "当前时间:"${date}

pid=$(ps -ef | grep elasticsearch | grep -v grep | awk '{print $2}')
if [ $pid ];then
    echo "elasticsearch已启动，进程:"${pid}
else
    echo "elasticsearch未启动，准备启动..."
    /home/avalon/elasticsearch/bin/elasticsearch -d
	sleep 3
    pid2=$(ps -ef | grep elasticsearch | grep -v grep | awk '{print $2}')
    if [ ${pid2} ];then
        echo "elasticsearch启动成功，进程:"${pid2}
		exit 0
    else
        echo "elasticsearch启动失败！"
    fi
fi

exit 0
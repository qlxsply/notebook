## 配置文件
[Redis主节点配置文件](./../config/redis.cnf)

[Redis从节点配置文件](./../config/sentinel.cnf)

## 集群搭建

### [创建集群]()

```shell
#! /bin/bash
./src/redis-trib.rb create --replicas 1 192.168.50.201:6379 192.168.50.202:6379 192.168.50.203:6379 192.168.50.201:26379 192.168.50.202:26379 192.168.50.203:26379
exit 0
```

### 停止脚本
```shell
#!/bin/bash
date=`date '+%F %T'`
echo "当前时间:"${date}

pid=($(ps -ef | grep redis-server | grep -v grep | awk '{print $2}'))
for a in ${pid[*]}
do
    echo "Redis已启动，杀死原进程:"${a}
    kill -9 ${a}
done
```

### 启动脚本
```shell
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
./src/redis-server  /home/docker/redis/redis.conf
./src/redis-server  /home/docker/redis/sentinel.conf --sentinel
sleep 1

pid2=($(ps -ef | grep redis-server | grep -v grep | awk '{print $2}'))
for b in ${pid2[*]}
do
    echo "Redis已启动，进程:"${b}
done
```

### redis编译
```shell
MALLOC=libc
```


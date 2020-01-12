## 配置文件
[Redis主节点配置文件](./../config/redis.conf)

[Redis从节点配置文件](./../config/sentinel.conf)

## 集群搭建

### [创建集群]()

```shell
#! /bin/bash
/home/docker/redis/src/redis-trib.rb create --replicas 1 127.0.0.1:6379 192.168.50.202:6379 192.168.50.203:6379 127.0.0.1:26379 192.168.50.202:26379 192.168.50.203:26379
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

sudo yum -y install zlib ruby rubygems



sudo yum install -y patch automake bison bzip2 libffi-devel libtool patch readline-devel sqlite-devel zlib-devel openssl-devel



```
./configure -prefix=/usr/local/ruby

sudo yum -y remove ruby

make && make install

export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar'


export PATH=/usr/local/ruby/bin:$PATH 

/home/docker/redis/src/redis-trib.rb create --replicas 1 127.0.0.1:6379 192.168.50.202:6379 192.168.50.203:6379 127.0.0.1:26379 192.168.50.202:26379 192.168.50.203:26379

#进入 172.1.50.1.11
docker exec -it clm1 bash
/ # redis-cli
127.0.0.1:6379> auth 123456
127.0.0.1:6379> info cluster
127.0.0.1:6379> cluster meet 172.1.50.12 6379
127.0.0.1:6379> cluster meet 172.1.50.13 6379
127.0.0.1:6379> cluster meet 172.1.30.11 6379
127.0.0.1:6379> cluster meet 172.1.30.12 6379
127.0.0.1:6379> cluster meet 172.1.30.13 6379
127.0.0.1:6379> cluster nodes
```

## 常用操作

### 通用

```shell
#查看当前key_value数据类型
#type key
127.0.0.1:7777> type a
hash

#选择当前操作数据库，索引从0开始
127.0.0.1:7777> select 0
OK

#删除有一个key
127.0.0.1:7777> del my_key
(integer) 1
```

### hash

```shell
#设置
#hset key field value
127.0.0.1:7777> hset a age 12
(integer) 1

#查看hash表中，指定的field是否存在，存在则返回正整数1，反之返回0
#hexists key field
127.0.0.1:7777> hexists a name
(integer) 1

#获取hash表中所有value值
#hvals key
127.0.0.1:7777> hvals a
1) "zhangsan"
2) "15200872769"

#获取hash表中
#hmget key field1 [field2]
127.0.0.1:7777> hmget a name age mobile
1) "zhangsan"
2) (nil)
3) "15200872769"

#获取hash表中
#hmset key field1 value1 [field2 value2]
127.0.0.1:7777> hmset a  filed1 "asdf" filed2 "zxcv"
OK

#删除一个或多个哈希表字段
#hdel key field1 [field2]
127.0.0.1:7777> hdel a test age
(integer) 1

#获取hash表中，指定属性的值
#hget key field
127.0.0.1:7777> hget a age
"23"

#获取在哈希表中指定 key 的所有字段和值
#hgetall key
127.0.0.1:7777> hgetall a
1) "name"
2) "zhangsan"
3) "mobile"
4) "15200872769"
5) "age"
6) "23"

#为哈希表key中的指定字段的整数值加上增量increment，返回更新后的值
#hincrby key field increment
127.0.0.1:7777> hincrby a age 1
(integer) 24

#为哈希表key中的指定字段的浮点数值加上增量increment，返回更新后的值
#hincrbyfloat key field increment
127.0.0.1:7777> hincrbyfloat a age 1.2
"25.2"

#获取hash表中key对应的全部field
#hkeys key
127.0.0.1:7777> hkeys a
1) "name"
2) "mobile"
3) "age"

#获取hash表中key对应的全部field数量
#hlen key
127.0.0.1:7777> hlen a
(integer) 3

#当hash表中key对应的filed不存在时，才设置对应的值，失败返回0
#hsetnx key field value
127.0.0.1:7777> hsetnx a age 122
(integer) 0
```

### List

```shell
#在列表头部插入一个或多个值，返回加入元素后的列表长度，如下语法value1先进入列表，value2后进入列表变成头部
#lpush key value1 [value2]
127.0.0.1:7777> lpush  my_key  1 2 3 4 5
(integer) 5 

#将一个值插入到已存在的列表头部，不存在则返回0，存在则返回列表长度
127.0.0.1:7777> lpushx my_key 6
(integer) 6

#查看列表长度
127.0.0.1:7777> llen my_key
(integer) 6

#通过列表索引获取列表中的元素，列表头部索引从0开始，如果key不存在或者越界返回nil
127.0.0.1:7777> lindex my_key 5
"1"

#移除并获取列表第一元素
127.0.0.1:7777> lpop my_key 
"6"

#移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。时间单位秒
127.0.0.1:7777> blpop my_key 5
1) "my_key"
2) "6"

#移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
127.0.0.1:7777> brpop my_key 5
1) "my_key"
2) "1"

#获取指定范围内的元素，队列头部索引为0，索引范围为[start,stop]闭区间,[0,-1]表示获取全部元素
# lrange key start stop
127.0.0.1:7777> lrange my_key 0 -1
1) "3"
2) "2"
3) "1"

#Lrem 根据参数 COUNT 的值，移除列表中与参数 VALUE 相等的元素
#lrem key count value
#count > 0 : 从表头开始向表尾搜索，移除与 VALUE 相等的元素，数量为 COUNT 。
#count < 0 : 从表尾开始向表头搜索，移除与 VALUE 相等的元素，数量为 COUNT 的绝对值。
#count = 0 : 移除表中所有与 VALUE 相等的值。
127.0.0.1:7777> lrem my_key 3 1
(integer) 3

#通过索引设置列表元素的值
127.0.0.1:7777> lset my_key 1 7
OK

#对列表进行修剪(trim)，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除
#下标0表示列表的第一个元素，以-1表示列表的最后一个元素，ltrim my_key -1 0 删除全部元素
127.0.0.1:7777> ltrim my_key 1 1
OK

#从列表尾部开始添加元素
127.0.0.1:7777> rpush my_key 1 2 3 4 5
(integer) 5

#若列表存在，则从列表尾部开始添加一个元素，若当前key已存在但不是列表类型，返回错误，列表不存在则返回0
127.0.0.1:7777> rpushx my_key 2
(integer) 2

#从队列尾部移除一个元素
127.0.0.1:7777> rpop my_key
"2"
```


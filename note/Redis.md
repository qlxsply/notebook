## 配置文件
```shell
# 只监听配置的IP请求
bind 0.0.0.0
# 是否开启保护模式，默认开启。
protected-mode no
# 监听端口号
port 7001
# TCP连接最大数量，linux系统默认最大连接数量为128，可在/etc/sysctl.conf文件中添加net.core.somaxconn = 2048增大linux的tcp连接数量限制
tcp-backlog 512
# 配置unix socket来让redis支持监听本地连接。不配置则无法监听unix连接
unixsocket "./redis_7021.sock"
# 配置unix socket使用文件的权限
unixsocketperm 700
# 客户端超时断开时间，0表示不主动断开
timeout 0
# HTTP keep-alive 告诉客户端和服务器TCP握手建立成功后。在请求响应完成后不要立刻断开TCP连接，后续http请求复用该TCP连接
# TCP keepalive TCP保活计时器（keepalive timer），服务器判断客户端是否还存活的一种机制
tcp-keepalive 300

################################# GENERAL #####################################
# 以守护进程方式运行 即以后台运行方式去启动
daemonize yes
# 监督模式，不知道有什么用
supervised no
# pid文件
pidfile "./redis_7001.pid"
# 日志级别
loglevel debug
# 日志文件
logfile "./redis.log"
# 设置数据库的数量，默认数据库为16，可以使用select <dbid>命令在连接上指定数据库id
databases 1
# 日志logo，没什么用
always-show-logo yes

################################ SNAPSHOTTING  ################################
# rdb频率  save <seconds> <changes> seconds：间隔时间 changes：key值改变次数
save 900 1
save 300 10
save 60 10000
# 如果rdb失败，是否停止写入操作
stop-writes-on-bgsave-error yes
# 是否压缩rdb文件
rdbcompression yes
# 是否校验rdb文件，开启降低性能增加文件安全性
rdbchecksum yes
# rdb文件名
dbfilename dump.rdb
# 默认redis的工作路径
dir ./

################################# REPLICATION #################################
# 从节点设置主节点ip+port
# slaveof <masterip> <masterport>
# 主节点密码
# masterauth <master-password>
# 当从节点失去主节点连接后的操作：
# yes:继续响应客户端的请求
# no:除了INFO和SLAVEOF命令之外的任何请求都会返回一个错误
# slave-serve-stale-data yes
# 从节点是否只读
# slave-read-only yes
# 主从复制方式是否使用无磁盘复制，
# yes:master创建一个新的进程，直接把rdb文件以socket的方式逐个发给slave
# no:master创建一个新的进程把rdb文件保存到磁盘，再把磁盘上的rdb文件传递给多个slave。
# repl-diskless-sync yes
# 开启无磁盘复制后，一旦复制开始，节点不会再接收新slave的复制请求直到下一个rdb传输，所以需要设置一个延迟时间，尽可能一次发送给多个slave
# repl-diskless-sync-delay 5
# slave根据指定的时间间隔向服务器发送ping请求。时间间隔可以通过 repl_ping_slave_period 来设置，默认10秒。
# repl-ping-slave-period 10
# 复制连接超时时间。
# master和slave都有超时时间的设置。master检测到slave上次发送的时间超过repl-timeout，即认为slave离线，清除该slave信息。
# slave检测到上次和master交互的时间超过repl-timeout，则认为master离线。
# 需要注意的是repl-timeout需要设置一个比repl-ping-slave-period更大的值，不然会经常检测到超时。
# repl-timeout 60
# 在同步完成之后是否关闭TCP_NODELAY
# yes:更加节省带宽，但是会增加数据同步的延迟
# no:将减少数据在从节点的延迟，但是将使用更多带宽进行复制。
# repl-disable-tcp-nodelay no
# 复制缓冲区大小
# repl-backlog-size 1mb
# 当主节点断开一段时间后，释放缓冲区
# repl-backlog-ttl 3600
# 当主节点不可用时，根据该优先级选择新的主节点，0表示不能成为主节点
slave-priority 1
# 当从节点数量小于该数字时禁止写入
min-slaves-to-write 0
# 从节点最大延迟，大于该值则认为从节点失效
min-slaves-max-lag 10

################################## SECURITY ###################################
# 密码
#requirepass asdfasdf
# 命令重写
# rename-command CONFIG ""

################################### CLIENTS ####################################
# 客户端最大并发连接数
maxclients 10000

############################## MEMORY MANAGEMENT ################################
# 指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key
# 当此方法处理后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。
maxmemory 2gb
# 淘汰策略
# 1）volatile-lru   利用LRU算法移除设置过过期时间的key (LRU:最近使用 Least Recently Used )
# 2）allkeys-lru   利用LRU算法移除任何key
# 3）volatile-random 移除设置过过期时间的随机key
# 4）allkeys-random  移除随机ke
# 5）volatile-ttl   移除即将过期的key(minor TTL)
# 6）noeviction  noeviction   不移除任何key，只是返回一个写错误 ，默认选项
maxmemory-policy volatile-lru
# LRU, LFU and minimal TTL 算法抽样数量
maxmemory-samples 5

############################# LAZY FREEING ####################################
# 惰性删除或延迟释放；当删除键的时候,redis提供异步延时释放key内存的功能，
# 把key释放操作放在bio(Background I/O)单独的子线程处理中，减少删除big key对redis主线程的阻塞。
# 有效地避免删除big key带来的性能和可用性问题。
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no

############################## APPEND ONLY MODE ###############################
# 启动时Redis都会先把这个文件的数据读入内存里，先忽略RDB文件。
appendonly yes
appendfilename "appendonly.aof"
# appendfsync everysec 表示每秒执行一次fsync，可能会导致丢失这1s数据
# appendfsync always 表示每次写入都执行fsync，以保证数据同步到磁盘。
# appendfsync no 表示不执行fsync，由操作系统保证数据同步到磁盘，速度最快。
appendfsync always
# 在aof重写或者写入rdb文件的时候，会执行大量IO，此时对于everysec和always的aof模式来说，执行fsync会造成阻塞过长时间
# yes表示rewrite期间对新写操作不fsync,暂时存在内存中,等rewrite完成后再写入
no-appendfsync-on-rewrite no
# aof自动重写配置，当目前aof文件大小超过上一次重写的aof文件大小的百分之多少进行重写
auto-aof-rewrite-percentage 100
# aof重写最小文件大小
auto-aof-rewrite-min-size 64mb
# 如果选择的是yes，当截断的aof文件被导入的时候，会自动发布一个log给客户端然后load
# 如果是no，用户必须手动redis-check-aof修复AOF文件才可以。
aof-load-truncated yes
# RDB和AOF混合模式，RDB格式的内容用于记录已有的数据，而AOF格式的内存则用于记录最近发生了变化的数据
aof-use-rdb-preamble no

################################ LUA SCRIPTING  ###############################
# 如果达到最大时间限制（毫秒），redis会记个log，然后返回error。当一个脚本超过了最大时限。
# 只有SCRIPT KILL和SHUTDOWN NOSAVE可以用。第一个可以杀没有调write命令的东西。
# 要是已经调用了write，只能用第二个命令杀
lua-time-limit 100

################################ REDIS CLUSTER  ###############################
# 集群开关，默认是不开启集群模式
cluster-enabled yes
# 集群配置文件的名称，每个节点都有一个集群相关的配置文件，持久化保存集群的信息。
cluster-config-file nodes-201.conf
#  节点互连超时的阀值，集群节点超时毫秒数
cluster-node-timeout 15000
# 在进行故障转移的时候，全部slave都会请求申请为master，但是有些slave可能与master断开连接一段时间了，
# 导致数据过于陈旧，这样的slave不应该被提升为master。该参数就是用来判断slave节点与master断线的时间是否过长。
cluster-slave-validity-factor 10
# 当该其他节点在失去从节点后，如果当前节点有多余从节点可以将自己的从节点迁移至目标master，
# 迁移后自己的从节点数量不能少于cluster-migration-barrier
cluster-migration-barrier 1
#  yes:当所有节点都正常工作时才对外提供服务
cluster-require-full-coverage yes
# yes：当主服务器故障时，从服务器禁止故障迁移
cluster-slave-no-failover no

################################## SLOW LOG ###################################
# 慢查询标准
slowlog-log-slower-than 3000
# slowlog最大长度
slowlog-max-len 256

################################ LATENCY MONITOR ##############################
# 延迟监控功能是用来监控redis中执行比较缓慢的一些操作，用LATENCY打印redis实例在跑命令时的耗时图表。
# 只记录大于等于下边设置的值的操作，0的话，就是关闭监视。
# 默认延迟监控功能是关闭的，如果你需要打开，也可以通过CONFIG SET命令动态设置。
latency-monitor-threshold 0

############################# EVENT NOTIFICATION ##############################
notify-keyspace-events ""

############################### ADVANCED CONFIG ###############################
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
# client-query-buffer-limit 1gb
# proto-max-bulk-len 512mb
hz 10
# 在aof重写的时候，如果打开了aof-rewrite-incremental-fsync开关，系统会每32MB执行一次fsync。
aof-rewrite-incremental-fsync yes
# lfu-log-factor 10
# lfu-decay-time 1
```

## 集群搭建

### 初始脚本

```shell
#!/bin/bash
read -p "注意：执行该脚本将清空当前路径下的全部数据，确认请输入 'y'或'yes'  " choose
if [[ $choose != "yes" ]] && [[ $choose != "y" ]]
then
    echo "退出脚本"
    exit 0;
fi
###-----------------------------节点数量设置-----------------------------
nodeSize=6
local=($(pwd))
###-----------------------------节点配置文件-----------------------------
for((i=1;i<=${nodeSize};i++));
do
    node=$(expr $i + 7000)
    rm -rf ${local}/${node}
    mkdir -p ${local}/${node}
    echo -e "bind 0.0.0.0
protected-mode no
port ${node}
tcp-backlog 128
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile "${local}/${node}/redis_${node}.pid"
loglevel debug
logfile "${local}/${node}/redis.log"
databases 1
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir ${local}/${node}/
maxclients 10000
maxmemory 1gb
maxmemory-policy volatile-lru
maxmemory-samples 5
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no
appendonly yes
appendfilename "appendonly.aof"
appendfsync always
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble no
lua-time-limit 5000
cluster-enabled yes
cluster-config-file ${local}/${node}/nodes-${node}.conf
cluster-node-timeout 15000
cluster-slave-validity-factor 10
cluster-migration-barrier 1
cluster-require-full-coverage yes
cluster-slave-no-failover no
slowlog-log-slower-than 10000
slowlog-max-len 256
latency-monitor-threshold 0
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes" > ${local}/${node}/${node}.conf
done
###------------------------------完成-----------------------------
exit 0
```

### 集群脚本

```shell
#! /bin/bash
/home/redis/redis/src/redis-cli --cluster create 192.168.50.201:7001 192.168.50.201:7002 192.168.50.201:7003 192.168.50.201:7004 192.168.50.201:7005 192.168.50.201:7006 --cluster-replicas 1
exit 0
```

### 关机脚本
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
###-----------------------------启动-----------------------------
nodeSize=6
local=($(pwd))
for((i=1;i<=${nodeSize};i++));
do
    node=$(expr $i + 7000)
    /home/redis/redis/src/redis-server ${local}/${node}/${node}.conf
	sleep 1
done
###-----------------------------完成-----------------------------
pid2=($(ps -ef | grep redis-server | grep -v grep | awk '{print $2}'))
for b in ${pid2[*]}
do
    echo "Redis已启动，进程:"${b}
done
```

### 问题记录
```shell
----------------------------------问题描述-----------------------------
cc: error: ../deps/hiredis/libhiredis.a: No such file or directory
cc: error: ../deps/lua/src/liblua.a: No such file or directory
make[1]: *** [redis-server] Error 1
make[1]: Leaving directory `/usr/local/src/redis-4.0.1/src'
make: *** [all] Error 2
----------------------------------解决方案-----------------------------
1.>进入deps目录
2.>执行如下命令	make lua hiredis linenoise
```

## 常用操作

### cluster

#### 集群状态

```shell
127.0.0.1:7003> cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:3
cluster_stats_messages_ping_sent:616
cluster_stats_messages_pong_sent:556
cluster_stats_messages_sent:1172
cluster_stats_messages_ping_received:556
cluster_stats_messages_pong_received:552
cluster_stats_messages_received:1108
#cluster_state 集群状态，如果有部分slots不能正常工作，该属性将变为no，写入操作将失败，设置cluster-require-full-coverage配置参数为no可以取消该限制。
#cluster_slots_assigned 已分配的槽数量
#cluster_slots_fail 失效的槽数量
#cluster_known_nodes 集群中的节点数量
#cluster_size 集群分片数量
```

#### 集群节点

```shell
127.0.0.1:7003> cluster nodes
23eec45ea56bad33ac34c9f3916aca4c014196c8 192.168.50.201:7003@17003 myself,master - 0 1579970125000 3 connected 10923-16383
c173e1334668d80b08c6a10d18183b23d41c4caa 192.168.50.201:7005@17005 slave 23eec45ea56bad33ac34c9f3916aca4c014196c8 0 1579970127236 3 connected
426422e3db8532bcbfd1fa7d763add09d55ea570 192.168.50.201:7006@17006 slave 3c340a01e89fe8f5efe20b32a094f1782f70c3e6 0 1579970128244 6 connected
2e0a0e5157d354cfedacdb0350aec42b0888c356 192.168.50.201:7004@17004 slave c15553f9e8635d6fbc1a0e9ffab5ab525489880c 0 1579970127000 2 connected
c15553f9e8635d6fbc1a0e9ffab5ab525489880c 192.168.50.201:7002@17002 master - 0 1579970129252 2 connected 5461-10922
3c340a01e89fe8f5efe20b32a094f1782f70c3e6 192.168.50.201:7001@17001 master - 0 1579970126229 1 connected 0-5460
```

#### 集群分片

```shell
127.0.0.1:7003> cluster slots
1) 1) (integer) 10923
   2) (integer) 16383
   3) 1) "192.168.50.201"
      2) (integer) 7003
      3) "23eec45ea56bad33ac34c9f3916aca4c014196c8"
   4) 1) "192.168.50.201"
      2) (integer) 7005
      3) "c173e1334668d80b08c6a10d18183b23d41c4caa"
2) 1) (integer) 5461
   2) (integer) 10922
   3) 1) "192.168.50.201"
      2) (integer) 7002
      3) "c15553f9e8635d6fbc1a0e9ffab5ab525489880c"
   4) 1) "192.168.50.201"
      2) (integer) 7004
      3) "2e0a0e5157d354cfedacdb0350aec42b0888c356"
3) 1) (integer) 0
   2) (integer) 5460
   3) 1) "192.168.50.201"
      2) (integer) 7001
      3) "3c340a01e89fe8f5efe20b32a094f1782f70c3e6"
   4) 1) "192.168.50.201"
      2) (integer) 7006
      3) "426422e3db8532bcbfd1fa7d763add09d55ea570"
```

#### 当前节点

```shell
127.0.0.1:7003> cluster myid
"23eec45ea56bad33ac34c9f3916aca4c014196c8"
```

#### 计算key对应槽位

```shell
#
127.0.0.1:7003> cluster keyslot a
(integer) 15495
```

### common

#### 查看value数据类型

```shell
#type key
127.0.0.1:7777> type a
hash
```

#### 选择数据库

```shell
#选择当前操作数据库，索引从0开始
127.0.0.1:7777> select 0
OK
```

#### 删除key

```shell
#删除有一个key
127.0.0.1:7777> del my_key
(integer) 1
```

#### key剩余有效时间

```shell
#返回剩余时间（单位：秒）
127.0.0.1:7003> ttl ket_001
(integer) -2
#返回剩余时间（单位：毫秒）
127.0.0.1:7003> pttl ket_001
(integer) -2
#如果key设置了有效时间并过期，返回-2
#如果key没有设置有效时间，返回-1
```

#### 查看key列表

```shell
#方式1：keys命令 KEYS PATTERN
127.0.0.1:7002> keys k*
1) "key1"
#keys命令缺点：
#1.没有limit，返回所有符合条件的key。
#2.keys命令是遍历算法，时间复杂度是O(N)，会扫描所有key，容器照成服务器卡顿。
#方式2：scan命令 SCAN cursor [MATCH pattern] [COUNT count]
127.0.0.1:7002> scan 0 match key*
1) "0"
2) 1) "key9"
   2) "key5"
   3) "key1"
#优点：可以限制扫描key的数量，但是返回结果可能大于count指定的数量
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

## 分布式锁

### 普通实现

```shell
1.获取锁
SET resource_name unique_value NX PX 30000

2.释放锁（lua脚本中，一定要比较value，防止误解锁）
if redis.call("get",KEYS[1]) == ARGV[1] then
    return redis.call("del",KEYS[1])
else
    return 0
end

该实现方式有三个要点：
1.set命令要用具有原子性。
2.value需要具有唯一性，一般使用UUID即可。
3.释放锁的时候需要验证value的值，防止误解锁。

缺陷：
1.不可重入
2.加锁只作用于一个Redis节点上，如果发生主从切换，可能出现锁丢失的情况:
>应用在master节点获取到锁，此时数据还未同步至slave节点
>master节点故障，slave升级为新的master
>此时可能发生锁丢失
3.如果在获取锁之后应用陷入长时间的阻塞，那么可能会出现redis的锁实际已经失效，而自身还在操作目标资源的情况。
可以结合cas的方式处理这一问题。
```

### Redlock

```shell
假设集群环境下存在N个Redis master，这些节点间互相独立，没有集群协调机制。
获取锁的步骤：
1.获取当前时间（毫秒数）。
2.按顺序依次向N个Redis节点执行获取锁的操作。这个获取操作跟前面基于单Redis节点的获取锁的过程相同，包含随机字符串my_random_value，也包含过期时间(比如PX 30000，即锁的有效时间)。为了保证在某个Redis节点不可用的时候算法能够继续运行，这个获取锁的操作还有一个超时时间(time out)，它要远小于锁的有效时间（几十毫秒量级）。客户端在向某个Redis节点获取锁失败以后，应该立即尝试下一个Redis节点。这里的失败，应该包含任何类型的失败，比如该Redis节点不可用，或者该Redis节点上的锁已经被其它客户端持有（注：Redlock原文中这里只提到了Redis节点不可用的情况，但也应该包含其它的失败情况）。
3.计算整个获取锁的过程总共消耗了多长时间，计算方法是用当前时间减去第1步记录的时间。如果客户端从大多数Redis节点（>= N/2+1）成功获取到了锁，并且获取锁总共消耗的时间没有超过锁的有效时间(lock validity time)，那么这时客户端才认为最终获取锁成功；否则，认为最终获取锁失败。
4.如果最终获取锁成功了，那么这个锁的有效时间应该重新计算，它等于最初的锁的有效时间减去第3步计算出来的获取锁消耗的时间。
5.如果最终获取锁失败了（可能由于获取到锁的Redis节点个数少于N/2+1，或者整个获取锁的过程消耗的时间超过了锁的最初有效时间），那么客户端应该立即向所有Redis节点发起释放锁的操作（即前面介绍的Redis Lua脚本）。

失效场景1：
	1.客户端1从Redis节点A, B, C成功获取了锁（多数节点）。由于网络问题，与D和E通信失败。
	2.节点C上的时钟发生了向前跳跃，导致它上面维护的锁快速过期。
	3.客户端2从Redis节点C, D, E成功获取了同一个资源的锁（多数节点）。
	4.客户端1和客户端2现在都认为自己持有了锁。
原因：
	Redlock的安全性(safety property)对系统的时钟有比较强的依赖，一旦系统的时钟变得不准确，算法的安全性也就保证不了了。
总结：
	Martin在这里其实是要指出分布式算法研究中的一些基础性问题，或者说一些常识问题，即好的分布式算法应该基于异步模型(asynchronous model)，算法的安全性不应该依赖于任何记时假设(timing assumption)。在异步模型中：进程可能pause任意长的时间，消息可能在网络中延迟任意长的时间，甚至丢失，系统时钟也可能以任意方式出错。一个好的分布式算法，这些因素不应该影响它的安全性(safety property)，只可能影响到它的活性(liveness property)，也就是说，即使在非常极端的情况下（比如系统时钟严重错误），算法顶多是不能在有限的时间内给出结果而已，而不应该给出错误的结果。这样的算法在现实中是存在的，像比较著名的Paxos，或Raft。但显然按这个标准的话，Redlock的安全性级别是达不到的。
	Martin对锁的用途的进行了划分。把锁的用途分为两种：
	为了效率(efficiency)，协调各个客户端避免做重复的工作。即使锁偶尔失效了，只是可能把某些操作多做一遍而已，不会产生其它的不良后果。比如重复发送了一封同样的email。
	为了正确性(correctness)。在任何情况下都不允许锁失效的情况发生，因为一旦发生，就可能意味着数据不一致(inconsistency)，数据丢失，文件损坏，或者其它严重的问题。
```


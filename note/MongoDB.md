## 集群部署

### 基本概念

#### mongos

​	mongo集群入口，所有请求都通过mongos进行路由分发，方便应用层透明使用，mongos自己就是一个请求分发中心，它负责把对应的数据请求请求转发到对应的shard服务器上。在生产环境通常有多mongos作为请求的入口，防止其中一个挂掉所有的mongodb请求都没有办法操作。

#### config server

​	配置服务器，存储所有数据库元信息（路由、分片）的配置，其中包括chunk信息。mongos本身没有物理存储分片服务器和数据路由信息，只是缓存在内存里，配置服务器则实际存储这些数据。mongos第一次启动或者关掉重启就会从 config server 加载配置信息，以后如果配置服务器信息变化会通知到所有的 mongos 更新自己的状态，这样 mongos 就能继续准确路由。在生产环境通常有多个 config server 配置服务器，因为它存储了分片路由的元数据，防止数据丢失。

#### shard

​	分片服务器，实际存储数据，一个shard server角色可以由几台服务器组成一个replica set承担，防止主机单点故障。

#### replica set

​	副本集，由多台机器组成的shard备份，当其中某台机器宕机，该分片整体还能保持可用。

#### arbiter

​	replica set中的一个mongo实例，不保存数据，用于保证副本集中有基数的投票成员。

#### primary shard

​	使用 MongoDB sharding 后，数据会以 chunk 为单位（默认64MB）根据 `shardKey` 分散到后端1或多个 shard 上。每个 database 会有一个 `primary shard`，在数据库创建时分配：

- database 下启用分片（即调用 `shardCollection` 命令）的集合，刚开始会生成一个[minKey, maxKey] 的 chunk，该 chunk 初始会存储在 `primary shard` 上，然后随着数据的写入，不断的发生 chunk 分裂及迁移，整个过程如下图所示。
- database 下没有启用分片的集合，其所有数据都会存储到 `primary shard`

### 基本原理

#### 数据分布策略

​	Sharded cluster支持将单个集合的数据分散存储在多个shard上，用户可以指定根据集合内文档的某个字段即shard key来分布数据，目前主要支持2种数据分布的策略，范围分片（Range based sharding）或hash分片（Hash based sharding）。

##### 范围分片

优点：范围分片能很好的满足 "范围查询" 的需求，例如需要查询age在0-18的全部用户，此时可以直接进行类似于扫表的操作，读取指定范围的值即可。

缺点：如果shardkey呈现明显递增(减)趋势，那么新增文档都会集中在同一个chunk，不利于写能力提升。

##### hash分片

​	先根据用户的shard key计算hash值（64bit整型），再根据该hash值按 "范围分片" 规则进行分片。

优点：扩展了写能力

缺点：不能高效进行范围查询

### 机器分配

|       | 192.168.50.201 | 192.168.50.202 | 192.168.50.203 |
| ----- | -------------- | -------------- | -------------- |
| 27000 | mongos         | mongos         | mongos         |
| 27999 | config         | config         | config         |
| 27001 | shard1主节点   | shard1副节点   | shard1副节点   |
| 27002 | shard2副节点   | shard2主节点   | shard2副节点   |
| 27003 | shard3副节点   | shard3副节点   | shard3主节点   |

### 部署准备

#### 环境变量

```shell
export MONGODB_HOME=/home/avalon/mongodb/bin
export PATH=$MONGODB_HOME:$PATH
```

#### 单点模式

```shell
/home/avalon/mongodb/bin/mongod --dbpath=/home/avalon/mongodb/data --logpath=/home/avalon/mongodb/logs/mongodb.log --pidfilepath=/home/avalon/mongodb/mongo.pid --bind_ip_all --maxConns 128 --logappend --port=27017 --noauth --fork
```

#### 初始脚本

```shell
#!/bin/bash
read -p "注意：执行该脚本将清空当前路径下的全部数据，确认请输入 'y'或'yes'  " choose
if [[ $choose != "yes" ]] && [[ $choose != "y" ]]
then
    echo "退出脚本"
    exit 0;
fi
###-----------------------------分片节点的数量设置--------------------
shardSize=3
###配置服务和路由服务文件夹创建
local=($(pwd))
confPath=${local}/conf
mongosServerPath=${local}/mongos
configServerPath=${local}/config
###路由节点mongos的配置服务集群设置
configdb=configs/192.168.50.201:27999,192.168.50.202:27999,192.168.50.203:27999
###创建相关目录与文件
rm -rf ${confPath}
mkdir -p ${confPath}
rm -rf ${mongosServerPath}
mkdir -p ${mongosServerPath}/log
rm -rf ${configServerPath}
mkdir -p ${configServerPath}/data
mkdir -p ${configServerPath}/log
###创建keyfile，并修改文件权限
echo -e "jRDjQhRMJpVAdh87UsNudvPTD9gMWTgzuUaWKbOXnEcJQhs4+/qS+ZpofFpxg5FQ
XM7+WqG3qlTv6TOKP3wOPXGxcBYGxh4x30QwOF26W1rfLF28dzlwp2Jave6g5SgV
NXbc90JOL69NUPJsTZx6K/T2KhK+bj3QKzx4kWL8LhnQnnSLI1AT2GWgBCpLMV3/
zyPWoQhTPNmEbezdx4/+uR69O2z6oCmHt352W6hnxClEc/sA2xL3Ul+yEbIhqkTO
AhG1FNxN941+9A5EB1IMM1MzfLf1LE8ul+lKfJ9cuhp6eRzJ+WmSaHehPhV5QWos
CoBk4qsVcjpRk4dD6ZNdyq7PQFcOvgXVw/u3PiG0buUq1BXULUOd0YKsxg1B2hIl
/tn6eZAsm9P15HOke7QJSM+TLP2jjHISzswOOGberXY2c7x+mWF37jQC2rUCm7dF
ksx43J9qX6Li0Yr1n65nlowleoatuvypRbo2wl9076RsuewdnUhrLniykbk5Yh71
9LMcsvkDfAIcivF26j192W6GpUJ/3a59VJ8GZNNovDJ7PmxpEG8MGKnSyHZMqw5g
dt8QNptw/3JPsVcpVUiKmF7qBqYzuJXSN4Z2Smbv5FIoAJnJtXfvqnASWajW7vs5
FqX+DeFjrFBHqQ8AWPLOst595sWH716nRkGUM+72MneNl7qDhdWgzlNIHCk24jK8
Al5qCvJKpJJRmj6y7IwzjL3QomstYpmFCyJPX4CRjs5YiOy5mfAQsjm8O37Ntu7u
CJ6JlWc550E3xos/JWmdidMRLSFTCQmVvyV7djzPt9thHLI1/Ome3Mll/svRsd+w
0e1npWrbet71LDbOE/rjTah/i+YTv9QRlAcXTVbAwSDgKHhOFyIMCmgPlyUCgzFl
/3mxsEUK3GyXli081cDpK0AfR/Ik7b1L0o7ER94zmXmr5WTB6l4O0e9dtcogB03t
zjgij+1tnGZ3XC4CcYGPnKPl6AjEtdqLVQ==
" > ${confPath}/keyfile
chmod 600 ${confPath}/keyfile
###---------------------------------------config服务器配置文件------------------------
echo -e "dbpath=${configServerPath}/data
logpath=${configServerPath}/log/config.log
port=27999
bind_ip=0.0.0.0
logappend=true
fork=true
maxConns=512
replSet=configs
keyFile=${confPath}/keyfile
configsvr=true" > ${confPath}/config.conf
echo -e "dbpath=${configServerPath}/data
logpath=${configServerPath}/log/config.log
port=27999
bind_ip=0.0.0.0
logappend=true
fork=true
maxConns=512
auth=false
configsvr=true" > ${confPath}/config_init.conf
###---------------------------------mongos配置文件----------------------------
echo -e "fork=true
logpath=${mongosServerPath}/log/mongos.log
logappend=true
port=27000
maxConns=512
bind_ip=0.0.0.0
keyFile=${confPath}/keyfile
clusterAuthMode=keyFile
configdb=${configdb}" > ${confPath}/mongos.conf
###----------------------------------分片节点服务配置---------------------------
for((i=1;i<=${shardSize};i++));
do
    shardPath=$(expr $i + 27000)
    rm -rf ${local}/${shardPath}
    mkdir -p ${local}/${shardPath}/data
    mkdir -p ${local}/${shardPath}/log
    echo -e "dbpath=${local}/${shardPath}/data
logpath=${local}/${shardPath}/log/db.log
port=${shardPath}
bind_ip=0.0.0.0
storageEngine=mmapv1
shardsvr=true
logappend=true
fork=true
maxConns=512
keyFile=${confPath}/keyfile
replSet=${shardPath}" > ${confPath}/${shardPath}.conf
done
#-----用于初始化的配置文件，未开启集群，未指定keyfile------
for((i=1;i<=${shardSize};i++));
do
    shardPath=$(expr $i + 27000)
    rm -rf ${local}/${shardPath}
    mkdir -p ${local}/${shardPath}/data
    mkdir -p ${local}/${shardPath}/log
    echo -e "dbpath=${local}/${shardPath}/data
logpath=${local}/${shardPath}/log/db.log
port=${shardPath}
bind_ip=0.0.0.0
storageEngine=mmapv1
shardsvr=true
logappend=true
fork=true
maxConns=512
auth=false" > ${confPath}/${shardPath}_init.conf
done
###----------------------------------------启动脚本start.sh---------------------------
echo -e "
#!/bin/bash
mongod -f ${confPath}/config.conf
sleep 1
for((i=1;i<=${shardSize};i++));
do
    shardPath=\$(expr \$i + 27000)
    echo 'start '${confPath}/\${shardPath}.conf
    mongod -f ${confPath}/\${shardPath}.conf
    sleep 1
done
exit 0
" > ${local}/start.sh
###----------------------------------------关机脚本close.sh----------------------------
echo -e "
#!/bin/bash
mongod -f ${confPath}/config.conf --shutdown
sleep 1
for((i=1;i<=${shardSize};i++));
do
    shardPath=\$(expr \$i + 27000)
    echo 'close '${confPath}/\${shardPath}.conf
    mongod -f ${confPath}/\${shardPath}.conf --shutdown
    sleep 1
done
exit 0
" > ${local}/close.sh
###-----------------------------------------end--------------------------------
exit 0
```

#### Admin设置

```shell
#-------------------------------config server设置admin-------------------------
#------关闭keyfile、auth和副本集进行初始化
#关闭keyfile是因为配置keyfile后mongodb会强制打开auth，但是此时还没有可用的账号用于登录
#关闭副本集是因为副本集只能由主节点设置账号，但是没有账号就不能启动副本集并设置主节点，所以关闭
mongod -f /home/avalon/cluster/conf/config_init.conf
#------登录当前config server
mongo 192.168.50.201:27999
#------切换至admin库并创建账号
> use admin
> db.createUser({
 user:"configAdmin",
 pwd:"asdfasdf",
 roles: [ { role: "root",db:"admin"}]
}) 
#------验证，成功返回1
> db.auth('configAdmin','asdfasdf')
#------关闭config server
mongod -f /home/avalon/cluster/conf/config_init.conf --shutdown


#-------------------------------shard server设置admin-------------------------
#------初始化分片节点，你需要在哪一台机器登录并进行副本集的初始化操作就在哪一台机器启动
mongod -f /home/avalon/cluster/conf/27001_init.conf
#------依次登录分片节点，创建一个root账号
mongo 192.168.50.201:27001
#------切换至admin库并创建账号
> use admin
> db.createUser({
 user:"mongoAdmin",
 pwd:"asdfasdf",
 roles: [ { role: "root",db:"admin"}]
}) 
#------验证，成功返回1
> db.auth('mongoAdmin','asdfasdf')
#------关闭shard server
mongod -f /home/avalon/cluster/conf/27001_init.conf --shutdown
############---重复以上步骤为每个分片节点设置初始的账号---############
```

#### 集群设置

```shell
#-----------------通过start.sh正式启动配置服务和分片节点
sh start.sh
#-----------------登录有admin账号的服务，通过该节点来添加副本集
#------设置config server副本集
mongo 192.168.50.201:27999
> use admin
> db.auth('configAdmin','asdfasdf')
> rs.initiate({_id:"configs",members:[{_id:0,host:"192.168.50.201:27999"},{_id:1,host:"192.168.50.202:27999"}, {_id:2,host:"192.168.50.203:27999"}]})
> rs.status()
#------设置shard server副本集
mongo 192.168.50.201:27001
> use admin
> db.auth('mongoAdmin','asdfasdf')
> rs.initiate({_id:"27001",members:[{_id:0,host:"192.168.50.201:27001"},{_id:1,host:"192.168.50.202:27001"}, {_id:2,host:"192.168.50.203:27001"}]})
> rs.status()
#------设置shard server副本集
mongo 192.168.50.201:27002
> use admin
> db.auth('mongoAdmin','asdfasdf')
> rs.initiate({_id:"27002",members:[{_id:0,host:"192.168.50.201:27002"},{_id:1,host:"192.168.50.202:27002"}, {_id:2,host:"192.168.50.203:27002"}]})
> rs.status()
#------设置shard server副本集
mongo 192.168.50.201:27003
> use admin
> db.auth('mongoAdmin','asdfasdf')
> rs.initiate({_id:"27003",members:[{_id:0,host:"192.168.50.201:27003"},{_id:1,host:"192.168.50.202:27003"}, {_id:2,host:"192.168.50.203:27003"}]})
> rs.status()
```

#### 路由服务

```shell
#mongos用于提供集群内分片的路由服务，mongos本身不保存任何数据，所以启动参数必须指定集群的config副本集
mongos -f /home/avalon/cluster/conf/mongos.conf
#链接mongos服务
mongo 192.168.50.201:27000
#登录config服务中的账号
mongos> use admin
switched to db admin
mongos> db.auth('configAdmin','asdfasdf')
1
#添加分片副本集，集群元数据都会保存在config服务中，mongos每次启动都会去config服务查询集群元数据，并以此对各种请求进行路由
> sh.addShard("27001/192.168.50.201:27001,192.168.50.202:27001,192.168.50.203:27001")
> sh.addShard("27002/192.168.50.201:27002,192.168.50.202:27002,192.168.50.203:27002")
> sh.addShard("27003/192.168.50.201:27003,192.168.50.202:27003,192.168.50.203:27003")
> sh.status()
```

### 集合分片

```shell
#----设置chunk大小，默认64MB，设置为1M方便测试
mongos> use config
switched to db config
mongos> db.setting.save({"_id":"chunksize ","value":1})
WriteResult({ "nMatched" : 0, "nUpserted" : 1, "nModified" : 0, "_id" : "chunksize " })
#----创建仓库和对应账号
mongos> use avalon
switched to db avalon
mongos> db.createUser({
			user:"avalon",
			pwd:"asdfasdf",
			roles: [ { role: "dbOwner",db:"avalon"}]
		}) 
Successfully added user: {
	"user" : "avalon",
	"roles" : [
		{
			"role" : "dbOwner",
			"db" : "avalon"
		}
	]
}
#----在指定的数据库上启用分片。为数据库启用分片后，即可用于sh.shardCollection()在该数据库中分片集合。
mongos> sh.enableSharding("avalon")
{
	"ok" : 1,
	"operationTime" : Timestamp(1578205846, 5),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1578205846, 5),
		"signature" : {
			"hash" : BinData(0,"4FFYaJXFeqBeR3zj3wEytN9xDjw="),
			"keyId" : NumberLong("6778326539122507800")
		}
	}
}
#----创建集合，使用自增索引
mongos> db.createCollection("user",{autoIndexId:true})
{
	"ok" : 1,
	"operationTime" : Timestamp(1578206035, 5),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1578206035, 5),
		"signature" : {
			"hash" : BinData(0,"hrAurB0lVRBmSww7xyRuX7dzes0="),
			"keyId" : NumberLong("6778326539122507800")
		}
	}
}
#----作为shardKey的字段必须是索引，分片策略是hashed，用于分片的索引也设置为hashed
mongos> db.user.createIndex({'name':'hashed'})
{
	"raw" : {
		"27001/192.168.50.201:27001,192.168.50.202:27001,192.168.50.203:27001" : {
			"createdCollectionAutomatically" : false,
			"numIndexesBefore" : 1,
			"numIndexesAfter" : 2,
			"ok" : 1
		}
	},
	"ok" : 1,
	"operationTime" : Timestamp(1578211367, 2),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1578211367, 2),
		"signature" : {
			"hash" : BinData(0,"6mllqWFBOVsNU2b7Unlmt/5nnY8="),
			"keyId" : NumberLong("6778326539122507800")
		}
	}
}
#----进行分片操作
mongos> sh.shardCollection("avalon.user", {"name": "hashed" }, false, {numInitialChunks: 3})
{
	"collectionsharded" : "mydb.user",
	"collectionUUID" : UUID("542c2694-03a8-4791-91d0-ebd594ddf680"),
	"ok" : 1,
	"operationTime" : Timestamp(1578208570, 23),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1578208570, 23),
		"signature" : {
			"hash" : BinData(0,"/nCYXL50Z6vnv/8hqHa+TNHqjYU="),
			"keyId" : NumberLong("6778326539122507800")
		}
	}
}
#-----插入测试数据
for(i=1;i<=100;i++){db.user.insert({"name":"user"+i})}
#---查看当前集合的数据分布情况
mongos> db.user.getShardDistribution()

Shard 27003 at 27003/192.168.50.201:27003,192.168.50.202:27003,192.168.50.203:27003
 data : 1KiB docs : 37 chunks : 1
 estimated data per chunk : 1KiB
 estimated docs per chunk : 37

Shard 27002 at 27002/192.168.50.201:27002,192.168.50.202:27002,192.168.50.203:27002
 data : 1KiB docs : 33 chunks : 1
 estimated data per chunk : 1KiB
 estimated docs per chunk : 33

Shard 27001 at 27001/192.168.50.201:27001,192.168.50.202:27001,192.168.50.203:27001
 data : 1KiB docs : 32 chunks : 1
 estimated data per chunk : 1KiB
 estimated docs per chunk : 32

Totals
 data : 4KiB docs : 102 chunks : 3
 Shard 27003 contains 36.27% data, 36.27% docs in cluster, avg obj size on shard : 48B
 Shard 27002 contains 32.35% data, 32.35% docs in cluster, avg obj size on shard : 48B
 Shard 27001 contains 31.37% data, 31.37% docs in cluster, avg obj size on shard : 48B
#----查看当前库的状态
mongos> db.stats()
#---查看具体某个集合的状态 db.collectionName.stats()
mongos> db.user.stats()
```

### 常用操作

#### 查看系统配置

```shell
#只能在admin库查看
mongos> db.runCommand( { getParameter : '*' } )
```

#### 索引管理

##### 创建

```shell
#创建索引
db.COLLECTION_NAME.createIndex({"name":1})
mongos> db.user.createIndex({'name':'hashed'})
{
	"raw" : {
		"27001/192.168.50.201:27001,192.168.50.202:27001,192.168.50.203:27001" : {
			"createdCollectionAutomatically" : false,
			"numIndexesBefore" : 1,
			"numIndexesAfter" : 2,
			"ok" : 1
		}
	},
	"ok" : 1,
	"operationTime" : Timestamp(1578208309, 1),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1578208309, 1),
		"signature" : {
			"hash" : BinData(0,"Grmo8zs4pj0VtscFO8tY8y+QQ9g="),
			"keyId" : NumberLong("6778326539122507800")
		}
	}
}
```

##### 删除

```shell
#删除指定索引dropIndex()
db.COLLECTION_NAME.dropIndex("INDEX-NAME")
#删除所有索引dropIndexes()
db.COLLECTION_NAME.dropIndexes()
```

##### 查看

```shell
#查看当前集合全部索引
db.COLLECTION_NAME.getIndexes()
mongos> db.user.getIndexes()
[
	{
		"v" : 2,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_",
		"ns" : "mydb.user"
	},
	{
		"v" : 2,
		"key" : {
			"name" : "hashed"
		},
		"name" : "name_hashed",
		"ns" : "mydb.user"
	}
]
#查看数据库中所有索引
db.system.indexes.find()
mongos> db.system.indexes.find()
{ "v" : 2, "key" : { "_id" : 1 }, "name" : "_id_", "ns" : "mydb.user" }
{ "v" : 2, "key" : { "name" : "hashed" }, "name" : "name_hashed", "ns" : "mydb.user" }
```

##### 重建

```shell
db.COLLECTION_NAME.reIndex()
```

### 问题记录

1.启动选项已经设置了auth=false，查看副本集或者设置副本集时提示没有登录

```shell
{
	"ok" : 0,
	"errmsg" : "command replSetGetStatus requires authentication",
	"code" : 13,
	"codeName" : "Unauthorized",
	"lastCommittedOpTime" : Timestamp(0, 0)
}
```

原因：启动参数开启了keyFile后，auth就自动开启，此时如果没有可用账号的话，就无法登录。

解决方法：每个shard可以由多个mongo实例组成，先启动一个实例不开启keyFile、auth和副本集模式（shardsvr、configsvr），在该实例上创建管理员账号。关闭该实例，开启keyFile和auth后启动，登录之前创建的管理员账号，添加副本集的其它节点。

2.副本集创建账号时返回错误，只有主节点才能创建账号

```shell
> use admin
switched to db admin
> db.createUser({
...  user:"mongoAdmin",
...  pwd:"asdfasdf",
...  roles: [ { role: "root",db:"admin"}]
... }) 
2020-01-04T05:12:16.010-0500 E QUERY    [js] Error: couldn't add user: not master :
_getErrorWithCode@src/mongo/shell/utils.js:25:13
DB.prototype.createUser@src/mongo/shell/db.js:1491:15
@(shell):1:1
```

原因：在处理第一个问题时，启动的实例如果只是关闭了keyFile和auth，但是依然使用副本集模式（shardsvr=true或者configsvr=true）,在创建账号时就会返回该错误，提示只有主节点才能创建用户

解决方法：关闭副本集模式

3.mongos添加副本集时提示需要认证

```
mongos> sh.addShard("27001/192.168.50.201:27001,192.168.50.202:27001,192.168.50.203:27001")
{
	"ok" : 0,
	"errmsg" : "command addShard requires authentication",
	"code" : 13,
	"codeName" : "Unauthorized",
	"operationTime" : Timestamp(1578140113, 1),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1578140113, 1),
		"signature" : {
			"hash" : BinData(0,"BFVLCyPG4zSu9hGZT08AozsP6aY="),
			"keyId" : NumberLong("6778039923069943837")
		}
	}
}
```

原因：mongos本身不存储任何数据，每次启动都是去config server获取集群的元数据，在配置文件中也指定了相应的config副本集信息，所以应当登录对应config副本集账号。

解决方法：登录config账号

### 副本集

```shell
#初始化副本集
> rs.initiate({
    "_id":"myReplSet",
    "members":[
        {
            "_id":1,
            "host":"192.168.50.201:27017",
            "priority":1
        },
        {
            "_id":2,
            "host":"192.168.50.205:27017",
            "priority":1
        }
    ]
})

#查看副本集状态
rs001:OTHER> rs.status()
{
	"set" : "rs001",
	"date" : ISODate("2020-03-14T09:18:15.355Z"),
	"myState" : 2,
	"term" : NumberLong(0),
	"syncingTo" : "",
	"syncSourceHost" : "",
	"syncSourceId" : -1,
	"heartbeatIntervalMillis" : NumberLong(2000),
	"optimes" : {
		"lastCommittedOpTime" : {
			"ts" : Timestamp(0, 0),
			"t" : NumberLong(-1)
		},
		"appliedOpTime" : {
			"ts" : Timestamp(1584177485, 1),
			"t" : NumberLong(-1)
		},
		"durableOpTime" : {
			"ts" : Timestamp(1584177485, 1),
			"t" : NumberLong(-1)
		}
	},
	"lastStableCheckpointTimestamp" : Timestamp(0, 0),
	"members" : [
		{
			"_id" : 1,
			"name" : "192.168.50.201:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 719,
			"optime" : {
				"ts" : Timestamp(1584177485, 1),
				"t" : NumberLong(-1)
			},
			"optimeDate" : ISODate("2020-03-14T09:18:05Z"),
			"syncingTo" : "",
			"syncSourceHost" : "",
			"syncSourceId" : -1,
			"infoMessage" : "could not find member to sync from",
			"configVersion" : 1,
			"self" : true,
			"lastHeartbeatMessage" : ""
		},
		{
			"_id" : 2,
			"name" : "192.168.50.202:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 9,
			"optime" : {
				"ts" : Timestamp(1584177485, 1),
				"t" : NumberLong(-1)
			},
			"optimeDurable" : {
				"ts" : Timestamp(1584177485, 1),
				"t" : NumberLong(-1)
			},
			"optimeDate" : ISODate("2020-03-14T09:18:05Z"),
			"optimeDurableDate" : ISODate("2020-03-14T09:18:05Z"),
			"lastHeartbeat" : ISODate("2020-03-14T09:18:14.939Z"),
			"lastHeartbeatRecv" : ISODate("2020-03-14T09:18:14.961Z"),
			"pingMs" : NumberLong(0),
			"lastHeartbeatMessage" : "",
			"syncingTo" : "",
			"syncSourceHost" : "",
			"syncSourceId" : -1,
			"infoMessage" : "",
			"configVersion" : 1
		}
	],
	"ok" : 1,
	"operationTime" : Timestamp(1584177485, 1),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1584177485, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	}
}

#副本集移除
rs001:PRIMARY> rs.remove("192.168.50.206:27017")

#副本集添加
rs001:PRIMARY> rs.add("192.168.50.206:27017")

#副本集配置
rs001:PRIMARY> rs.conf()
```

​		所有的Secondary都宕机、或则副本集中只剩下一个节点，则该节点只能为Secondary节点，也就意味着整个集群只能进行读操作而不能进行写操作，直到有节点恢复之后才能继续进行写操纵。
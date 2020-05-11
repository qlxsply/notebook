下载地址：
https://artifacts.elastic.co/downloads/kibana/kibana-5.6.11-linux-x86_64.tar.gz
https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.16.tar.gz

## elasticsearch配置文件

```yml
#--------------------------------单机单服务--------------------------------
cluster.name: es
node.name: 101
node.attr.rack: r1
path.data: /home/avalon/elasticsearch/data
path.logs: /home/avalon/elasticsearch/logs
bootstrap.memory_lock: true
network.host: 192.168.50.101
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.50.101","192.168.50.102","192.168.50.103"]
discovery.zen.minimum_master_nodes: 2
gateway.recover_after_nodes: 3
action.destructive_requires_name: true
node.master: true
node.data: true
#--------------------------------单机多服务--------------------------------
cluster.name: es-cluster
node.name: node1
node.attr.rack: r1
path.data: /home/avalon/es-cluster/node1/data
path.logs: /home/avalon/es-cluster/node1/logs
bootstrap.memory_lock: true
network.host: 192.168.50.200
http.port: 19201
transport.tcp.port: 19301
discovery.zen.ping.unicast.hosts : ["192.168.50.200:19301,19302,19303"]
discovery.zen.minimum_master_nodes: 2
gateway.recover_after_nodes: 1
node.max_local_storage_nodes: 1024
action.destructive_requires_name: true
node.master: true
node.data: true
#--------------------------------end--------------------------------



server.port: 5601
server.host: "192.168.50.100"
elasticsearch.url: "http://192.168.50.101:9200"
logging.dest: /home/avalon/kibana/kibana.log
logging.verbose: true
kibana.index: kibana


docker run -d --restart=always --log-driver json-file --log-opt max-size=100m --log-opt max-file=2 --name kibana -p 5601:5601 -v /home/docker/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml kibana:5.6.16
```



## elasticsearch问题总结

[3] bootstrap checks failed
[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
[2]: memory locking requested for elasticsearch process but memory is not locked
[3]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

表示每个进程可同时打开的文件数太小，可通过以下命令查看当前数量

``` shell
#查看资源的硬性限制，即管理员所设下的限制。
 -a 　显示目前资源限制的设定。  
     -c <core文件上限> 　设定core文件的最大值，单位为区块。  
     -d <数据节区大小> 　程序数据节区的最大值，单位为KB。  
     -f <文件大小> 　shell所能建立的最大文件，单位为区块。  
     -H 　设定资源的硬性限制，也就是管理员所设下的限制。  
     -m <内存大小> 　指定可使用内存的上限，单位为KB。  
     -n <文件数目> 　指定同一时间最多可打开的文件数。  
     -p <缓冲区大小> 　指定管道缓冲区的大小，单位512字节。  
     -s <堆栈大小> 　指定堆叠的上限，单位为KB。  
     -S 　设定资源的弹性限制。  
     -t <CPU时间> 　指定CPU使用时间的上限，单位为秒。  
     -u <进程数目> 　用户最多可启动的进程数目。 
     -v <虚拟内存大小> 　指定可使用的虚拟内存上限，单位为KB。
[root@192 ~]# ulimit -Hn
4096
#查看资源的弹性限制。
[root@192 ~]# ulimit -Sn
1024
#修改方法
[root@192 ~]# vim /etc/security/limits.conf
#文件末尾新增，第一个参数指定用户（*表示任意用户），第二个参数可设置hard、soft、-，分别表示硬性设置最大值，警告值和两者合并，第三个参数表示参数类型，nofile表示最大打开的文件数。
avalon          hard    nofile          65536
avalon          soft    nofile          65536
#重启后确认指定用户的设置值
[avalon@192 ~]$ ulimit -Hn
65536
```

第二行错误表示当前用户拥有的内存权限太小了，至少需要262144

``` shell
#编辑/etc/sysctl.conf文件，在末尾添加vm.max_map_count = 262144
[root@192 ~]# vim /etc/sysctl.conf
#sysctl -p使设置值生效
[root@192 ~]# sysctl -p
vm.max_map_count = 262144
```

[1]: memory locking requested for elasticsearch process but memory is not locked

```shell
[root@192 ~]# vim /etc/security/limits.conf
* hard nofile 65536
* soft nofile 65536
* soft memlock unlimited
* hard memlock unlimited
或者
avalon  hard nofile  65536
avalon  soft nofile  65536
avalon  soft memlock unlimited
avalon  hard memlock unlimited
```

## 开机启动脚本

### 创建启动文件

cd /etc/init.d
vim es
chmod 777 es

```shell
#!/bin/bash
#chkconfig: 345 63 37
#description: elasticsearch
#processname: elasticsearch

export JAVA_HOME=/home/avalon/jdk1.8.0_151
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

ES_HOME=/home/avalon/elasticsearch
case $1 in
    start)
        su avalon<<EOF
			cd $ES_HOME
			./bin/elasticsearch -d -p pid
			exit
EOF
        echo "elasticsearch is started"
        ;;
				
    stop)
        pid=`cat $ES_HOME/pid`
        kill -9 $pid
        echo "elasticsearch is stopped"
        ;;
				
    restart)
        pid=`cat $ES_HOME/pid`
        kill -9 $pid
        echo "elasticsearch is stopped"
        sleep 1
        su avalon<<EOF
            cd $ES_HOME
            ./bin/elasticsearch -d -p pid
            exit
EOF
        echo "elasticsearch is started"
		;;
	*)
		echo "start|stop|restart"
        ;;  
esac

exit 0
```
### 添加和删除服务并设置启动方式
chkconfig --add es【添加系统服务】
chkconfig --del es 【删除系统服务】

### 关闭和启动服务
service es start	【启动】
service es stop	【停止】
service es restart【重启】

### 设置服务开机启动
chkconfig es on【开启】
chkconfig es off【关闭】

## 常见操作

### 相关命令

#### _cat

```shell
_cat系列提供了一系列查询Elasticsearch集群状态的接口。
每个命令都支持使用?v参数，让输出内容表格显示表头; pretty则让输出缩进更规范

/_cat/allocation      #查看单节点的shard分配整体情况
/_cat/shards          #查看各shard的详细情况
/_cat/shards/{index}  #查看指定分片的详细情况
/_cat/master          #查看master节点信息
/_cat/nodes           #查看所有节点信息
/_cat/indices         #查看集群中所有index的详细信息
/_cat/indices/{index} #查看集群中指定index的详细信息
/_cat/segments        #查看各index的segment详细信息,包括segment名, 所属shard, 内存(磁盘)占用大小, 是否刷盘
/_cat/segments/{index}#查看指定index的segment详细信息
/_cat/count           #查看当前集群的doc数量
/_cat/count/{index}   #查看指定索引的doc数量
/_cat/recovery        #查看集群内每个shard的recovery过程.调整replica。
/_cat/recovery/{index}#查看指定索引shard的recovery过程
/_cat/health          #查看集群当前状态：红、黄、绿
/_cat/pending_tasks   #查看当前集群的pending task
/_cat/aliases         #查看集群中所有alias信息,路由配置等
/_cat/aliases/{alias} #查看指定索引的alias信息
/_cat/thread_pool     #查看集群各节点内部不同类型的threadpool的统计信息,
/_cat/plugins         #查看集群各个节点上的plugin信息
/_cat/fielddata       #查看当前集群各个节点的fielddata内存使用情况
/_cat/fielddata/{fields}     #查看指定field的内存使用情况,里面传field属性对应的值
/_cat/nodeattrs              #查看单节点的自定义属性
/_cat/repositories           #输出集群中注册快照存储库
/_cat/templates              #输出当前正在存在的模板信息
```

### 创建索引

```shell
#number_of_shards：每个索引的主分片数，默认值是 5 。这个配置在索引创建后不能修改。
#number_of_replicas：每个主分片的副本数，默认值是 1 。对于活动的索引库，这个配置可以随时修改。
#refresh_interval：索引刷新频率
{
    "settings": {
        "number_of_shards": 5,
        "number_of_replicas": 1,
        "refresh_interval":"-1",
        "analysis": {
            "char_filter": { ... custom character filters ... },
            "tokenizer":   { ...    custom tokenizers     ... },
            "filter":      { ...   custom token filters   ... },
            "analyzer":    { ...    custom analyzers      ... }
        }
    }
}
#自定义过滤器
"char_filter": {
    "&_to_and": {
        "type":       "mapping",
        "mappings": [ "&=> and "]
    }
}
#自定义分词器
"filter": {
    "my_stopwords": {
        "type":        "stop",
        "stopwords": [ "the", "a" ]
    }
}                           
#分析器（）=字符过滤器（char_filter）+分词器（filter）+词元过滤器（filter）
#es内置的分词器（analyzer）：standard、simple、whitespace、keyword、custom
#ik内置分词器：ik_smart（会做最粗粒度的拆分） ik_max_word（会将文本做最细粒度的拆分）
```

### 动态映射

当 Elasticsearch 遇到文档中以前未遇到的字段，通过dynamic来确定字段的数据类型并自动把新的字段添加到类型映射。

```shell
dynamic
true   :动态添加新的字段—缺省
false  :忽略新的字段
strict :如果遇到新字段抛出异常

PUT /my_index
{
    "mappings": {
        "my_type": {
            "dynamic":      "strict", 
            "properties": {
                "title":  { "type": "string"},
                "stash":  {
                    "type":     "object",
                    "dynamic":  true 
                }
            }
        }
    }
}
```

## springboot整合


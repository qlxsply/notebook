下载地址：
https://artifacts.elastic.co/downloads/kibana/kibana-5.6.11-linux-x86_64.tar.gz
https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.16.tar.gz

## elasticsearch配置文件

```yml
# ---------------------------------- Cluster -----------------------------------
cluster.name: es
# ------------------------------------ Node ------------------------------------
node.name: 101
node.attr.rack: r1
# ----------------------------------- Paths ------------------------------------
path.data: /home/avalon/elasticsearch/data
path.logs: /home/avalon/elasticsearch/logs
# ----------------------------------- Memory -----------------------------------
bootstrap.memory_lock: true
# ---------------------------------- Network -----------------------------------
network.host: 192.168.50.101
http.port: 9200
# --------------------------------- Discovery ----------------------------------
discovery.zen.ping.unicast.hosts: ["192.168.50.101", "192.168.50.102","192.168.50.103"]
discovery.zen.minimum_master_nodes: 2
# ---------------------------------- Gateway -----------------------------------
gateway.recover_after_nodes: 3
# ---------------------------------- Various -----------------------------------
action.destructive_requires_name: true
node.master: true
node.data: true


server.port: 5601
server.host: "192.168.50.100"
elasticsearch.url: "http://192.168.50.101:9200"
logging.dest: /home/avalon/kibana/kibana.log
logging.verbose: true
kibana.index: kibana

docker run -p 10001:1358 -d appbaseio/dejavu

```



## elasticsearch问题总结

[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
[2]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

第一行错误表示每个进程可同时打开的文件数太小，可通过以下命令查看当前数量

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

```shell
#编辑文件
sudo vim /etc/rc.d/rc.local
sh /home/avalon/elasticsearch/start.sh &
```

## springboot整合


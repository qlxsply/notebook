## ZooKeeper集群搭建

### 配置文件

```shell
#数据存放路径
dataDir=/home/bd/zookeeper/data
#日志文件存放路径
dataLogDir=/home/bd/zookeeper/logs
#心跳时间间隔，单位毫秒，客户端和服务器或者服务器之间维持心跳，每间隔tickTime时间就会发送一次心跳。
tickTime=2000
#客户端连接服务器的端口，默认2181
clientPort=2181
#集群中的follower服务器与leader服务器之间初始连接时能容忍的最多心跳数（tickTime的数量）
initLimit=3
#集群中的follower服务器与leader服务器之间的请求和应答最多能容忍的心跳数。   
syncLimit=2
#快照和事务日志的清理频率，单位是小时，需要填写一个1或更大的整数，默认是0，表示不开启自动清理功能。
autopurge.purgeInterval=4
#配合purgeInterval参数使用，指定需要保留的文件数量
autopurge.snapRetainCount=3
#客户端最大连接数量
maxClientCnxns=128
#true:如果以单点模式启动则不允许添加节点，如果集群方式启动则不能减少至少于两个节点。建议设置为false
standaloneEnabled=false
#zookeeper内嵌管理控制台
admin.serverPort=40000
admin.enableServer=true
#server.A=B:C:D 其中A是一个数字，表示这个是第几号服务器；B是这个服务器的ip地址；C表示的是这个服务器与集群中的Leader服务器交换信息的端口；D表示的是万一集群中的Leader服务器挂了，需要一个端口来重新进行选举，选出一个新的Leader，而这个端口就是用来执行选举时服务器相互通信的端口。
server.1=192.168.50.201:2888:3888
server.2=192.168.50.202:2888:3888
server.3=192.168.50.203:2888:3888
```

### 服务管理

```shell
/home/bd/zookeeper/bin/zkServer.sh --config /home/bd/zookeeper/conf start {start|stop|restart|status}
```

### 客户端

```shell
./zkCli.sh -timeout 1000 -server 192.168.1.201:2181
```

### 问题

```shell
1.org.apache.zookeeper.server.quorum.QuorumPeerMain
	从目前的最新版本3.5.5开始，带有bin名称的包才是我们想要的下载可以直接使用的里面有编译后的二进制的包，而之前的普通的tar.gz的包里面是只是源码的包无法直接使用。
2.Caused by: java.lang.IllegalArgumentException: myid file is missing
	在data目录下创建myid文件，内部设置一个数字表示当前节点序号，应当和server.A=B:C:D参数中的A一致。
```


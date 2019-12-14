## Docker安装

### centos安装docker

#### 1.验证当前版本是否支持docker

```shell
uname -r
3.10.0-957.el7.x86_64
该命令用于查看当前系统的内核版本
```

#### 2.移除旧版docker

```shell
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
```

#### 3.安装相关工具包

```shell
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

#### 4.添加软件源

```shell
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

#### 5.更新yum缓存

```shell
sudo yum makecache fast
```

#### 6.安装docker-ce

```shell
sudo yum -y install docker-ce
```

#### 7.启动docker服务

```shell
#启动docker服务
sudo systemctl start docker
#设置开机启动docker
sudo systemctl enable docker.service
```

#### 8.测试

```shell
[mysql@localhost ~]$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete 
Digest: sha256:b8ba256769a0ac28dd126d584e0a2011cd2877f3f76e093a7ae560f2a5301c00
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.
```

#### 9.修改镜像源

```shell
sudo vim  /etc/docker/daemon.json
```

#### 10.配置阿里云加速

```shell
https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors
https://3t9ge6my.mirror.aliyuncs.com

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://3t9ge6my.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Docker命令

### 镜像

#### 1.搜索镜像

```shell
#在docker index中搜索image
docker search <image>
--automated=false 仅显示自动创建的镜像
--no-trunc=false 输出信息不截断显示
-s 0 指定仅显示评价为指定星级的镜像
```

#### 2.下载镜像

```shell
#从docker registry server 中下拉image
docker pull <image> 
```

#### 3.查看镜像

```shell
#列出images
docker images
#列出所有的images（包含历史）
docker images -a 
#查看镜像元数据
docker inspect mysql:5.7
```

#### 4.删除镜像

```shell
#删除一个或多个image
docker rmi <image ID>
```

#### 5.导入导出镜像

```shell
#存出本地镜像文件为.tar
docker save -o ubuntu_14.04.tar ubuntu:14.04
#导入镜像到本地镜像库
docker load --input ubuntu_14.04.tar或者
docker load < ubuntu_14.04.tar
```

#### 6.创建镜像

```shell
docker build 命令用于使用 Dockerfile 创建镜像。
docker build [OPTIONS] PATH | URL | -
OPTIONS说明：
--build-arg=[] :设置镜像创建时的变量；
--cpu-shares :设置 cpu 使用权重；
--cpu-period :限制 CPU CFS周期；
--cpu-quota :限制 CPU CFS配额；
--cpuset-cpus :指定使用的CPU id；
--cpuset-mems :指定使用的内存 id；
--disable-content-trust :忽略校验，默认开启；
-f :指定要使用的Dockerfile路径；
--force-rm :设置镜像过程中删除中间容器；
--isolation :使用容器隔离技术；
--label=[] :设置镜像使用的元数据；
-m :设置内存最大值；
--memory-swap :设置Swap的最大值为内存+swap，"-1"表示不限swap；
--no-cache :创建镜像的过程不使用缓存；
--pull :尝试去更新镜像的新版本；
--quiet, -q :安静模式，成功后只输出镜像 ID；
--rm :设置镜像成功后删除中间容器；
--shm-size :设置/dev/shm的大小，默认值是64M；
--ulimit :Ulimit配置。
--tag, -t: 镜像的名字及标签，通常 name:tag 或者 name 格式；可以在一次构建中为一个镜像设置多个标签。
--network: 默认 default。在构建期间设置RUN指令的网络模式
```

### 容器

容器是镜像的一个运行实例，不同的是它带有额外的可写层。
可认为docker容器就是独立运行的一个或一组应用，以及它们所运行的必需环境。

#### 1.查看容器

```shell
#列出本机所有容器
docker ps -a
# -a 显示全部容器，不加该选项则仅显示正在运行的容器
```

#### 2.运行容器

```shell
docker run -i -t REPOSITORY:TAG
#等价于先执行docker create 再执行docker start 命令
-t	让docker分配一个伪终端并绑定到容器的标准输入上
-i	让容器的标准输入保持打开
-d	以守护态（daemonized）形式运行
```

#### 3.容器起动、停止、重启

```shell
#开启/停止/重启container
docker start/stop/restart <container> 
docker start [OPTIONS] CONTAINER [CONTAINER...]
docker stop [OPTIONS] CONTAINER [CONTAINER...]
docker restart [OPTIONS] CONTAINER [CONTAINER...]
```

#### 4.进入容器

```shell
#连接一个正在运行的container实例（即实例须为start状态，可以多个窗口同时attach一个container实例），但当某个窗口因命令阻塞时，其它窗口也无法执行了。
docker attach [container_id] 
```

#### 5.删除容器

```shell
#删除一个或多个container
docker rm <container...>
#删除所有的container
docker rm `docker ps -a -q`
#同上, 删除所有的container
docker ps -a -q | xargs docker rm 
```

#### 6.提交容器

```shell
#将一个container固化为一个新的image，后面的repo:tag可选。
docker commit <container> [repo:tag] 
```

#### 7.运行容器

```shell
docker run ：创建一个新的容器并运行一个命令
命令：
	docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
-a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；
-d: 后台运行容器，并返回容器ID；
-i: 以交互模式运行容器，通常与 -t 同时使用；
-P: 随机端口映射，容器内部端口随机映射到主机的高端口
-p: 指定端口映射，格式为：主机(宿主)端口:容器端口
-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
--name="nginx-lb": 为容器指定一个名称；
--dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致；
--dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致；
-h "mars": 指定容器的hostname；
-e username="ritchie": 设置环境变量；
--env-file=[]: 从指定文件读入环境变量；
--cpuset="0-2" or --cpuset="0,1,2": 绑定容器到指定CPU运行；
-m :设置容器使用内存最大值；
--net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；
--link=[]: 添加链接到另一个容器；
--expose=[]: 开放一个端口或一组端口；
--volume , -v: 绑定一个卷
```

#### 8.查看日志

``` shell
docker logs [OPTIONS] CONTAINER
#OPTIONS说明：
#-f : 跟踪日志输出
#--since :显示某个开始时间的所有日志
#-t : 显示时间戳
#--tail :仅列出最新N条容器日志
docker logs --since="2019-11-01" --tail=20 mysql
```

## Dockfile

```shell
	Dockfile是一个用于编写docker镜像生成过程的文件，其有特定的语法。在一个文件夹中，如果有一个名字为Dockfile的文件，其内容满足语法要求，在这个文件夹路径下执行命令:docker build --tag name:tag .，就可以按照描述构建一个镜像了。name是镜像的名称，tag是镜像的版本或者是标签号，不写就是lastest。注意后面有一个空格和点。
```

#### 1.FROM

```shell
用法：FROM <image>
　　说明：第一个指令必须是FROM了，其指定一个构建镜像的基础源镜像，如果本地没有就会从公共库中拉取，没有指定镜像的标签会使用默认的latest标签，可以出现多次，如果需要在一个Dockerfile中构建多个镜像。
```

#### 2.MAINTAINER

```shell
　用法：MAINTAINER <name> <email>
　	说明：描述镜像的创建者，名称和邮箱
```

#### 3.RUN

```shell
用法：RUN "command" "param1" "param2"
　　说明：RUN命令是一个常用的命令，执行完成之后会成为一个新的镜像，这里也是指镜像的分层构建。一句RUN就是一层，也相当于一个版本。这就是之前说的缓存的原理。我们知道docker是镜像层是只读的，所以你如果第一句安装了软件，用完在后面一句删除是不可能的。所以这种情况要在一句RUN命令中完成，可以通过&符号连接多个RUN语句。RUN后面的必须是双引号不能是单引号（没引号貌似也不要紧），command是不会调用shell的，所以也不会继承相应变量，要查看输入RUN "sh" "-c" "echo" "$HOME"，而不是RUN "echo" "$HOME"。
```

#### 4.CMD

```shell
用法：CMD command param1 param2
　　说明：CMD在Dockerfile中只能出现一次，有多个，只有最后一个会有效。其作用是在启动容器的时候提供一个默认的命令项。如果用户执行docker run的时候提供了命令项，就会覆盖掉这个命令。没提供就会使用构建时的命令。
```

#### 5.EXPOSE

```shell
用法：EXPOSE <port> [<port>...]
	说明：告诉Docker服务器容器对外映射的容器端口号，在docker run -p的时候生效。
```

#### 6.ENV

```shell
用法：EVN <key> <value> 只能设置一个
	 EVN <key>=<value>允许一次设置多个
	说明：设置容器的环境变量，可以让其后面的RUN命令使用，容器运行的时候这个变量也会保留。
```

#### 7.ADD

```shell
用法：ADD <src> <dest>
　　说明：复制本机文件或目录或远程文件，添加到指定的容器目录，支持GO的正则模糊匹配。路径是绝对路径，不存在会自动创建。如果源是一个目录，只会复制目录下的内容，目录本身不会复制。ADD命令会将复制的压缩文件夹自动解压，这也是与COPY命令最大的不同。
```

#### 8.COPY

```shell
用法：COPY <src> <dest>
	说明：COPY除了不能自动解压，也不能复制网络文件。其它功能和ADD相同。
```

#### 9.ENTRYPOINT

```shell
用法：ENTRYPOINT "command" "param1" "param2"
	说明：这个命令和CMD命令一样，唯一的区别是不能被docker run命令的执行命令覆盖，如果要覆盖需要带上选项--entrypoint，如果有多个选项，只有最后一个会生效。
```

#### 10.VOLUME

```shell
用法：VOLUME ["path"]
	说明：在主机上创建一个挂载，挂载到容器的指定路径。docker run -v命令也能完成这个操作，而且更强大。这个命令不能指定主机的需要挂载到容器的文件夹路径。但docker run -v可以，而且其还可以挂载数据容器。
```

#### 11.USER

```shell
用法：USER daemon
	说明：指定运行容器时的用户名或UID，后续的RUN、CMD、ENTRYPOINT也会使用指定的用户运行命令。
```

#### 12.WORKDIR

```shell
用法:WORKDIR path
	说明：为RUN、CMD、ENTRYPOINT指令配置工作目录。可以使用多个WORKDIR指令，后续参数如果是相对路径，则会基于之前的命令指定的路径。如：WORKDIR  /home　　WORKDIR test 。最终的路径就是/home/test。path路径也可以是环境变量，比如有环境变量HOME=/home，WORKDIR $HOME/test也就是/home/test。
```

#### 13.ONBUILD

```shell
用法：ONBUILD [INSTRUCTION]
	说明：配置当前所创建的镜像作为其它新创建镜像的基础镜像时，所执行的操作指令。意思就是，这个镜像创建后，如果其它镜像以这个镜像为基础，会先执行这个镜像的ONBUILD命令。
```

## Docker安装应用

#### MySQL

##### 1.拉取官方镜像

```shell
docker pull mysql:5.7
```

##### 2.在宿主机创建配置文件与相关文件夹

```shell
例如在/home/docker/mysql路径下创建
|data
|logs
	|---mysql.log
	|---mysql-slow.log
|my.cnf
```

##### 3.启动容器

```shell
docker run -p 3306:3306 --name mysql -v /home/docker/mysql:/etc/mysql/conf.d -v /home/docker/mysql/logs:/logs -v /home/docker/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=asdfasdf -d mysql:5.7
# --name 表示为容器指定一个名称
# -p 3306:3306 将容器的3306端口映射到主机的3306端口
# -v /home/mysql/mysql:/etc/mysql/conf.d 将宿主机当前目录下的/home/mysql/mysql/my.cnf 挂载到容器的/etc/mysql/my.cnf
# -v /home/mysql/mysql/log:/logs 将宿主机下的/home/mysql/mysql/log目录挂载到容器的/logs
# -v /home/mysql/mysql/data:/var/lib/mysql
# -e MYSQL_ROOT_PASSWORD=asdfasdf 设置root密码为asdfasdf
# -d 后台运行容器，并返回容器ID
# mysql:5.7 镜像名或者镜像ID
# -i 以交互模式运行容器通常与-t一同使用
# -t 为容器重新分配一个伪终端，通常与-i同时使用
#----------------------------------------------配置文件-------------------------------------
[client]
port=3306
socket=/tmp/mysql.sock

[mysqld]
skip-grant-tables
character_set_server=utf8mb4
collation_server=utf8mb4_general_ci
init_connect='SET NAMES utf8mb4'
#basedir=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64
#datadir=/var/lib/mysql
socket=/tmp/mysql.sock
#pid-file=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/mysql.pid
#log-error=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/error.log
#language=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/share/english
#慢查询日志
slow_query_log = 1
#slow_query_log_file=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/mysql-slow.log
#一般查询存储路径
general_log = 1
#general_log_file=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/mysql.log
#慢查询时间 超过1秒则为慢查询
long_query_time = 1 
#不区分大小写
lower_case_table_names=1
#绑定地址
bind-address=0.0.0.0
#0表示禁用缓存
query_cache_type=0
#设置Mysql的最大连接数
max-connections=100
#默认存储引擎
default-storage-engine = InnoDB
#当每进行1次事务提交之后，将数据写入磁盘。
sync_binlog=1
#当设为默认值1的时候，每次提交事务的时候，都会将log buffer刷写到日志。
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
#timestamp为null的时候，可能会报错
explicit_defaults_for_timestamp=true

log_bin=mysql_bin
binlog-format=Row
server-id=1

sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
max_connections=5000
default-time_zone = '+8:00'
```

##### 4.查看启动情况

```shell
[mysql@localhost data]$ docker ps 
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
e5f20026e86c        383867b75fd2        "docker-entrypoint.s…"   18 minutes ago      Up 18 minutes       0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```

##### 5.进入容器

```shell
#进入容器，后续操作和linux一致
docker exec -it mysql bash
```

##### 6.自制镜像

```shell
按照该配置，容器启动后会关闭，待解决
#-----------------------------------------Dockerfile文件---------------------------------------
#基础镜像
FROM centos:6.6
#签名
MAINTAINER avalon<rsjhshyzns@163.com>
RUN yum -y install numactl libaio
#拷贝并解压mysql
ADD mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz /usr/local
#定义环境变量
ENV WORK_HOME /usr/local/mysql-5.7.26-linux-glibc2.12-x86_64
#设置进入容器后的主目录
WORKDIR $WORK_HOME
#创建容器卷
VOLUME $WORK_HOME/data
VOLUME $WORK_HOME/log
#复制文件
COPY my.cnf $WORK_HOME/my.cnf
COPY setup.sh $WORK_HOME/setup.sh
COPY init.sql $WORK_HOME/init.sql
#增加mysql的bin目录的环境变量
ENV PATH $PATH:$WORK_HOME/bin
EXPOSE 3306 33060
ENTRYPOINT ["sh", "/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/setup.sh"]
#-----------------------------------------Dockerfile文件---------------------------------------

#-----------------------------------------setup.sh文件-----------------------------------------
#mysql启动脚本，每次开启容器时运行
#-----------------------------------------setup.sh文件-----------------------------------------
#!/bin/bash
date=`date '+%F %T'`
echo "当前时间:"${date}
pid=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
if [ $pid ];then
    echo "MySQL已启动，进程:"${pid}
else
    echo "MySQL未启动，准备启动..."
    mysqld --initialize --user=root --basedir=$WORK_HOME --datadir=$WORK_HOME/data
    mysqld --defaults-file=$WORK_HOME/my.cnf --user=root >/dev/null 2>&1 &
    sleep 3
    pid2=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
    if [ ${pid2} ];then
        echo "MySQL启动成功，进程:"${pid2}
        mysql < $WORK_HOME/init.sql
        exit 0
    else
        echo "MySQL启动失败！"
    fi
fi
exit 0

#-----------------------------------------init.sql文件-----------------------------------------
#用于修改root密码的sql脚本
#-----------------------------------------init.sql文件-----------------------------------------
use mysql;
update user set authentication_string = password('asdfasdf') where user='root';
flush privileges;

#-----------------------------------------my.cnf文件-------------------------------------------
#mysql配置文件
#-----------------------------------------my.cnf文件-------------------------------------------
[client]
port=3306
socket=/tmp/mysql.sock

[mysqld]
skip-grant-tables
character_set_server=utf8mb4
collation_server=utf8mb4_general_ci
init_connect='SET NAMES utf8mb4'
basedir=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64
datadir=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/data
socket=/tmp/mysql.sock
pid-file=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/mysql.pid
log-error=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/error.log
language=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/share/english
#慢查询日志
slow_query_log = 1
slow_query_log_file=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/mysql-slow.log
#一般查询存储路径
general_log = 1
general_log_file=/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log/mysql.log
#慢查询时间 超过1秒则为慢查询
long_query_time = 1 
#不区分大小写
lower_case_table_names=1
#绑定地址
bind-address=0.0.0.0
#0表示禁用缓存
query_cache_type=0
#设置Mysql的最大连接数
max-connections=100
#默认存储引擎
default-storage-engine = InnoDB
#当每进行1次事务提交之后，将数据写入磁盘。
sync_binlog=1
#当设为默认值1的时候，每次提交事务的时候，都会将log buffer刷写到日志。
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
#timestamp为null的时候，可能会报错
explicit_defaults_for_timestamp=true

log_bin=mysql_bin
binlog-format=Row
server-id=1

sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
max_connections=5000
default-time_zone = '+8:00'

#-----------------------------------------启动容器-------------------------------------------
#启动容器
#-----------------------------------------启动容器-------------------------------------------
docker build -f ./Dockerfile -t db:1.0 .
docker run -p 3306:3306 --name mysql -v /home/docker/mysql/logs:/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/log -v /home/docker/mysql/data:/usr/local/mysql-5.7.26-linux-glibc2.12-x86_64/data -d db:1.0
```

#### Zookeeper

##### 1.拉取镜像

```shell
docker pull zookeeper:3.5
```

##### 2.配置文件zoo.cfg

```shell
#数据存放路径
dataDir=/usr/zookeeper/data
#日志文件存放路径
dataLogDir=/usr/zookeeper/log
#心跳时间间隔，单位毫秒，客户端和服务器或者服务器之间维持心跳，每间隔tickTime时间就会发送一次心跳。
tickTime=2000
#客户端连接服务器的端口，默认2181
clientPort=2181
#集群中的follower服务器与leader服务器之间初始连接时能容忍的最多心跳数（tickTime的数量）
initLimit=3
#集群中的follower服务器与leader服务器之间的请求和应答最多能容忍的心跳数。   
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
maxClientCnxns=60
standaloneEnabled=true
admin.enableServer=true
#server.A=B:C:D 其中A是一个数字，表示这个是第几号服务器；B是这个服务器的ip地址；C表示的是这个服务器与集群中的Leader服务器交换信息的端口；D表示的是万一集群中的Leader服务器挂了，需要一个端口来重新进行选举，选出一个新的Leader，而这个端口就是用来执行选举时服务器相互通信的端口。
server.1=192.168.50.201:2888:3888
server.2=192.168.50.202:2888:3888
server.3=192.168.50.203:2888:3888
```

##### 3.启动容器

```shell
docker run -p 2181:2181 --name zookeeper --net host --restart always -v /home/docker/zookeeper/data:/usr/zookeeper/data -v /home/docker/zookeeper/log:/usr/zookeeper/log -v /home/docker/zookeeper/conf/zoo.cfg:/conf/zoo.cfg -e ZOO_MY_ID=1 -d zookeeper:3.5
```

##### 4.进入容器

```shell
#进入容器，后续操作和linux一致
docker exec -it zookeeper bash
```

##### 5.问题

```shell
1.Caused by: java.lang.IllegalArgumentException: myid file is missing
	原因：zk集群中的节点需要获取myid文件内容来标识该节点，缺失则无法启动
	解决：在zk数据文件存放目录下（通过zoo.cfg文件指定dataDir），创建myid文件并写入一个数字用来标识本节点（类似这个节点的身份证）。
2.java.net.NoRouteToHostException: No route to host (Host unreachable)
	原因：防火墙未关闭
	解决：sudo systemctl stop firewalld.service
		 sudo systemctl disable firewalld.service
```

#### Fabric

##### 1.安装fabric-ca

```shell
1.安装Go环境
sudo vim /etc/profile
export GOROOT=/home/docker/go
export PATH=$PATH:$GOROOT/bin
source /etc/profile
```

#### Redis

```shell
$ docker run -itd --name redis --restart always -p 6379:6379 redis:latest
# --name 表示为容器指定一个名称
# -p 6379:6379 将容器的6379端口映射到主机的6379端口
# -v /home/mysql/mysql/log:/logs 将宿主机下的/home/mysql/mysql/log目录挂载到容器的/logs
# -d 后台运行容器，并返回容器ID
# -i 以交互模式运行容器通常与-t一同使用
# -t 为容器重新分配一个伪终端，通常与-i同时使用
# redis:latest 镜像名或者镜像ID

docker exec -it redis /bin/bash
```


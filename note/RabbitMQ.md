# RabbitMQ

## 安装

### Erlang安装

#### 方法1

```shell
1.安装Erlang编译依赖:
sudo yum -y install gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel xmlto perl wget

2.下载Erlang：
wget http://erlang.org/download/otp_src_22.2.tar.gz

3.解压并安装
tar -xzvf otp_src_22.2.tar.gz
cd otp_src_22.2
./configure --prefix=/usr/local/erlang
sudo make && make install

4.配置环境变量
sudo vim /etc/profile
ERL_PATH=/usr/local/erlang/bin
PATH=$ERL_PATH:$PATH
source /etc/profile

#安装完成后，可以正常工作，但是安装rabbitMQ会提示版本过低
```

#### 方法2

```shell
1.安装依赖
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl-devel java-devel unixODBC-devel

2.添加erlang的yum源
vim /etc/yum.repos.d/rabbitmq-erlang.repo
[rabbitmq-erlang]
name=rabbitmq-erlang
baseurl=https://dl.bintray.com/rabbitmq-erlang/rpm/erlang/21/el/7
gpgcheck=1
gpgkey=https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc
repo_gpgcheck=0
enabled=1

3.sudo yum -y install erlang
```

### socat安装

```shell
sudo yum -y install socat
```

### RabbitMQ安装

```shell
1.下载安装包
wget https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.8.2/rabbitmq-server-3.8.2-1.el7.noarch.rpm

2.导入密钥
rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc

3.安装
rpm -ivh rabbitmq-server-3.8.2-1.el7.noarch.rpm
```

## 服务管理

### 启动停止

```shell
#启动
systemctl start rabbitmq-server.service
#停止
systemctl stop rabbitmq-server.service
#重启
systemctl restart rabbitmq-server.service
#开机自启
systemctl enable rabbitmq-server.service
#关闭自启
systemctl disable rabbitmq-server.service
#查看是否开机启动
systemctl is-enabled  rabbitmq-server.service
#查看状态
systemctl status rabbitmq-server.service
```

### web管理

```shell
#开启web插件
rabbitmq-plugins enable rabbitmq_management
#服务重启
service rabbitmq-server restart
```

### 用户管理

```shell
#查看所有用户
rabbitmqctl list_users
 
#添加一个用户
rabbitmqctl add_user avalon asdfasdf

#配置权限
rabbitmqctl set_permissions -p "/" avalon ".*" ".*" ".*"

#设置tag，相当于角色。
rabbitmqctl set_user_tags avalon administrator
 
#删除用户
rabbitmqctl delete_user avalon

#查看权限
rabbitmqctl list_user_permissions avalon
```

#### 用户角色

```shell
RabbitMQ用户角色分类：
none、management、policymaker、monitoring、administrator

none
不能访问 management plugin

management
用户可以通过AMQP做的任何事外加：
列出自己可以通过AMQP登入的virtual hosts  
查看自己的virtual hosts中的queues, exchanges 和 bindings
查看和关闭自己的channels 和 connections
查看有关自己的virtual hosts的“全局”的统计信息，包含其他用户在这些virtual hosts中的活动。

policymaker 
management可以做的任何事外加：
查看、创建和删除自己的virtual hosts所属的policies和parameters

monitoring  
management可以做的任何事外加：
列出所有virtual hosts，包括他们不能登录的virtual hosts
查看其他用户的connections和channels
查看节点级别的数据如clustering和memory使用情况
查看真正的关于所有virtual hosts的全局的统计信息

administrator   
policymaker和monitoring可以做的任何事外加:
创建和删除virtual hosts
查看、创建和删除users
查看创建和删除permissions
关闭其他用户的connections
```

#### 权限控制

```shell
set_permissions [-p <vhostpath>] <user> <conf> <write> <read>

	用户仅能对其所能访问的virtual hosts中的资源进行操作。这里的资源指的是virtual hosts中的exchanges、queues等，操作包括对资源进行配置、写、读。配置权限可创建、删除、资源并修改资源的行为，写权限可向资源发送消息，读权限从资源获取消息。
	exchange和queue的declare与delete分别需要exchange和queue上的配置权限
	exchange的bind与unbind需要exchange的读写权限
	queue的bind与unbind需要queue写权限exchange的读权限
	发消息(publish)需exchange的写权限
	获取或清除(get、consume、purge)消息需queue的读权限
```


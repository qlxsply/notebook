## docker安装

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
sudo systemctl start docker
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

## docker命令

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

### 容器

容器是镜像的一个运行实例，不同的是它带有额外的可写层。
可认为docker容器就是独立运行的一个或一组应用，以及它们所运行的必需环境。

#### 1.查看容器

```shell
#列出本机所有容器
docker ps -a
```

#### 2.创建容器

```shell
docker run -i -t REPOSITORY:TAG
#等价于先执行docker create 再执行docker start 命令
-t	让docker分配一个伪终端并绑定到容器的标准输入上
-i	让容器的标准输入保持打开
-d	以守护态（daemonized）形式运行
```

#### 3.容器管理

```shell
#开启/停止/重启container
docker start/stop/restart <container> 
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

## docker安装MySQL

### 1.拉取官方镜像

```shell
docker pull mysql:5.7
```

### 2.在宿主机创建配置文件与相关文件夹

```
例如在/home/mysql/mysql路径下创建
|data
|log
    |---mysql.log
    |---mysql-slow.log
|my.cnf
```

### 3.启动容器

```shell
docker run -p 3306:3306 --name mysql -v /home/mysql/mysql:/etc/mysql/conf.d -v /home/mysql/mysql/log:/logs -v /home/mysql/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=asdfasdf -d mysql:5.7
# -p 3306:3306 将容器的3306端口映射到主机的3306端口
# -v /home/mysql/mysql:/etc/mysql/conf.d 将宿主机当前目录下的/home/mysql/mysql/my.cnf 挂载到容器的/etc/mysql/my.cnf
# -v /home/mysql/mysql/log:/logs 将宿主机下的/home/mysql/mysql/log目录挂载到容器的/logs
# -v /home/mysql/mysql/data:/var/lib/mysql
# -e MYSQL_ROOT_PASSWORD=asdfasdf 设置root密码为asdfasdf
# -d 后台运行容器，并返回容器ID
# mysql:5.7 镜像名或者镜像ID
```

### 4.查看启动情况

```shell
[mysql@localhost data]$ docker ps 
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
e5f20026e86c        383867b75fd2        "docker-entrypoint.s…"   18 minutes ago      Up 18 minutes       0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```

### 5.进入容器

```shell
#进入容器，后续操作和linux一致
docker exec -it mysql bash
```

### 6.停止容器

```shell
docker stop e5f20026e86c
```
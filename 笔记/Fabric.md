## GOPATH GOROOT

```
	不同于其他语言，go中没有项目的说法，只有包, 其中有两个重要的路径，GOROOT 和GOPATH
GOROOT是安装目录，GOPATH是工作空间, 用来存放包的目录

	GOPATH可以设置多个，其中，第一个将会是默认的包目录，使用 go get 下载的包都会在第一个path中的src目录下，使用 go install时，在哪个GOPATH中找到了这个包，就会在哪个GOPATH下的bin目录生成可执行文件
```

## Docker

### 1.安装

```shell
sudo yum install docker
```

### 2.设置镜像

```shell
sudo vim /etc/docker/daemon.json
{
 "registry-mirrors": ["http://ef017c13.m.daocloud.io"],
 "live-restore": true
}
```

### 3.启动

```shell
sudo systemctl restart docker
```

### 4.测试docker

```shell
sudo docker run hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

## 安装docker-compose

```shell
curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```



## docker安装CA

```shell
docker pull hyperledger/fabric-ca
```


## 端口管理

### 防火墙管理

```shell
#防火墙启停查询
systemctl status firewalld
systemctl stop firewalld
systemctl disable firewalld
systemctl start  firewalld
#开放指定端口 --zone:作用域 --add-port=80/tcp:添加端口(端口/通讯协议) --permanent:是否永久生效
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
#查看指定端口开放情况
sudo firewall-cmd --zone=public --query-port=80/tcp
#取消端口开放
sudo firewall-cmd --zone=public --remove-port=80/tcp --permanent
#重启防火
sudo firewall-cmd --reload
#查看当前全部tcp端口
netstat -ntlp
```

### Domain Name System

```shell
cat /etc/resolv.conf
```

## 环境变量

```shell
export JAVA_HOME=/home/docker/jdk1.8.0_151
export PATH=$JAVA_HOME/bin:$PATH 
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

## 脚本

```shell
1.centos系统可通过/etc/rc.d/rc.local执行开机脚本和命令
2.修改/etc/rc.d/rc.local权限 chmod +x /etc/rc.d/rc.local
3.vim /etc/rc.d/rc.local
末尾添加 sh /home/avalon/bash/mysql-start.sh & //其中&表示后台运行
4.注意，启动时执行的脚本必须以exit 0结尾，表示程序正常执行完成并退出
```

## 应用

### tomcat

```shell
<role rolename="manager"/>    
<role rolename="manager-gui"/>    
<role rolename="admin"/>    
<role rolename="admin-gui"/>    
<role rolename="manager-script"/>    
<role rolename="manager-jmx"/>    
<role rolename="manager-status"/>    
<user username="avalon" password="asdfasdf" roles="admin-gui,admin,manager-gui,manager,manager-script,manager-jmx,manager-status"/> 

/home/avalon/tomcat/webapps/manager/META-INF 修改文件 context.xml 
allow="^.*$"
```

## 常见命令

### df命令

```shell
#磁盘空间使用情况查看（disk file system）
用法：df [选项]... [文件]...
  -a, --all             include pseudo, duplicate, inaccessible file systems
  -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
  -H, --si              likewise, but use powers of 1000 not 1024
  -i, --inodes		显示inode 信息而非块使用量
  -k			即--block-size=1K
  -l, --local		只显示本机的文件系统
      --no-sync		取得使用量数据前不进行同步动作(默认)
      --output[=FIELD_LIST]  use the output format defined by FIELD_LIST,
                               or print all fields if FIELD_LIST is omitted.
  -P, --portability     use the POSIX output format
      --sync            invoke sync before getting usage info
  -t, --type=TYPE       limit listing to file systems of type TYPE
  -T, --print-type      print file system type
  -x, --exclude-type=TYPE   limit listing to file systems not of type TYPE
  -v                    (ignored)
```

### free命令

```shell
#内存使用情况查看
Usage: free [options]
Options:
 -b, --bytes         show output in bytes
 -k, --kilo          show output in kilobytes
 -m, --mega          show output in megabytes
 -g, --giga          show output in gigabytes
     --tera          show output in terabytes
     --peta          show output in petabytes
 -h, --human         show human-readable output
     --si            use powers of 1000 not 1024
 -l, --lohi          show detailed low and high memory statistics
 -t, --total         show total for RAM + swap
 -s N, --seconds N   repeat printing every N seconds
 -c N, --count N     repeat printing N times, then exit
 -w, --wide          wide output
```

### head命令

```shell
#将每个文件的前10行打印到标准输出
用法：head [选项]... [文件]...
Print the first 10 lines of each FILE to standard output.
With more than one FILE, precede each with a header giving the file name.
With no FILE, or when FILE is -, read standard input.
Mandatory arguments to long options are mandatory for short options too.
  -c, --bytes=[-]K         print the first K bytes of each file;
                             with the leading '-', print all but the last
                             K bytes of each file
  -n, --lines=[-]K         print the first K lines instead of the first 10;
                             with the leading '-', print all but the last
                             K lines of each file
  -q, --quiet, --silent	不显示包含给定文件名的文件头
```

### tail命令

```shell
#打印文件后10行至标准输出
  -f, --follow[={name|descriptor}] output appended data as the file grows; an absent option argument means 'descriptor'
```

### less命令

```shell
#按显示文档，通过空格翻页
```

### wc命令

```shell
#单词统计
-c 统计字节数
-m 统计字符数
-w 统计单词数
-l 统计行数
```

### date命令

```shell
[avalon@bogon ~]$ date
2019年 07月 10日 星期三 21:42:56 CST
[avalon@bogon ~]$ date "+%Y-%m-%d"
2019-07-10
[avalon@bogon ~]$ date "+%F %T"
2019-07-10 21:46:56
[avalon@bogon ~]$ date "+%Y-%m-%d %H:%M:%S"
2019-07-10 21:50:45
```

### ps命令

```shell
#查看服务器进程信息
-e 列出全部进程
-f 显示全部的列
[avalon@bogon ~]$ ps -ef 
UID         PID   PPID  C STIME TTY          TIME CMD
root          2      0  0 22:49 ?        00:00:00 [kthreadd]
root          3      2  0 22:49 ?        00:00:00 [ksoftirqd/0]
root          5      2  0 22:49 ?        00:00:00 [kworker/0:0H]
UID			执行该进程的用户ID
PID          进程ID
PPID         该进程的父级进程ID。如果一个程序的父级进程找不到，该进程称为僵尸进程
C            cup占用率			
STIME        该进程的启用时间
TTY          终端设备，表示发起进程的终端设备，如果是"?"表示不是终端发起，而是系统自动发起的
TIME         进程执行的时间
CMD          该进程的名称或者对应的路径
```

### top命令

```shell
#查看服务器进程占的资源
top - 23:02:34 up 13 min,  2 users,  load average: 0.00, 0.04, 0.07
Tasks: 106 total,   2 running,  99 sleeping,   5 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  3861484 total,  3345632 free,   303208 used,   212644 buff/cache
KiB Swap:  4063228 total,  4063228 free,        0 used.  3306532 avail Mem 
PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND                             9993 avalon    20   0  161996   2228   1564 R 99.9  0.1   0:00.07 top                                 1 root      20   0  128020   6528   4132 S  0.0  0.2   0:01.53 systemd  
PID			进程ID
USER		该进程所属的用户
PR           优先级
NI           
VIRT		虚拟内存，申请了500M，实际使用了300M，此时虚拟内存为500M
RES			常驻内存，申请了500M，实际使用了300M，此时常驻内存为300M
SHR			共享内存，申请了500M，实际使用了300M，但是包含了对其它进程的调用开销，需要扣除 
S			状态，S表示睡眠，R表示运行
%CPU		CPU占用百分比
%MEM		内存占用百分比
TIME+		执行时间
COMMAND		进程名称或路径
快捷方式:
m			按进程占用内存由高到低排序
1			CPU按各个核心分别显示详细信息
p			按照CPU的使用率由高到低排列
```

### du命令

```shell
#查看目录的大小（disk usage）
-s, --summarize       display only a total for each argument
-h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
#查看当前目录下文件大小
[docker@localhost source]$ du -sh *
4.0K	Dockerfile
4.0K	init.sql
4.0K	my.cnf
615M	mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz
4.0K	setup.sh
```

### find命令

```shell
#文件查找命令
[avalon@bogon ~]$ find /home/avalon/ -name READ*
/home/avalon/mysql/share/charsets/README
/home/avalon/mysql/README
/home/avalon/jdk/lib/missioncontrol/dropins/README.TXT
/home/avalon/jdk/db/README-JDK.html
/home/avalon/jdk/jre/README
/home/avalon/jdk/README.html
/home/avalon/elasticsearch/jdk/conf/security/policy/README.txt
/home/avalon/elasticsearch/README.textile
[avalon@bogon ~]$ find /home/avalon/ -type f/d(文件/路径)
[avalon@bogon mysql]$ find ./ -name READ* | wc -l
2
-name，按照文档名称进行搜索（支持模糊搜索）
-type，根据文件类型进行搜索
```

### service命令

```shell
#用于控制服务的启动、停止、重启
service httpd start
```

### groups命令

```shell
#用于查看当前用户所属的用户组列表
```
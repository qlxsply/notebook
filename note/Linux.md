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

## 输入输出

### 输出从定向

```shell
#先将标准输出1重定向为null，再将标准错误输出2重定向至标准输出1，最终将丢失标准输出1和标准错误输出2
>/dev/null 2>&1
#先将标准错误输出2重定向至标准输出1，此时标准输出1还是输出到屏幕，再将标准输出1重定向至null，最终只会丢失标准错误输出
2>&1 >/dev/null
```



## 环境变量

```shell
export JAVA_HOME=/home/avalon/jdk1.8.0_151
export PATH=$JAVA_HOME/bin:$PATH 
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

## 开机脚本

```shell
1.centos系统可通过/etc/rc.d/rc.local执行开机脚本和命令
2.修改/etc/rc.d/rc.local权限 chmod +x /etc/rc.d/rc.local
3.vim /etc/rc.d/rc.local
末尾添加 sh /home/avalon/bash/mysql-start.sh & //其中&表示后台运行
4.注意，启动时执行的脚本必须以exit 0结尾，表示程序正常执行完成并退出
```

## 字体安装

```shell
# 1.将对应字体复制至/usr/share/fonts/文件夹内
/usr/share/fonts/字体文件夹/
# 2.
mkfontscale
# 3.
mkfontdir
# 4.扫描字体目录并生成字体信息的缓存
fc-cache -fv
-E, --error-on-no-fonts  raise an error if no fonts in a directory
-f, --force              scan directories with apparently valid caches
-r, --really-force       erase all existing caches, then rescan
-s, --system-only        scan system-wide directories only
-y, --sysroot=SYSROOT    prepend SYSROOT to all paths for scanning
-v, --verbose            display status information while busy
-V, --version            display font config version and exit
-h, --help               display this help and exit
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

## 常用软件

### rz  sz

```shell
sudo yum -y install lrzsz
```

### git

```shell
# 安装依赖
yum install -y autoconf automake libtool
yum install -y zlib-devel
# 解压
tar -zxvf git-2.29.2.tar.gz
# 
./configure --prefix=/usr/local/git
# root用户编译安装
make && make install
# 环境变量
vim /etc/profile
GIT_HOME=/usr/local/git
PATH=$PATH:$GIT_HOME/bin
source /etc/profile
```

### gcc

```shell
# 安装gcc-9.2.0.tar.gz
# 1.安装编译依赖库 切换root用户进行安装
tar -xvf isl-0.22.tar.gz
cd isl-0.22
./configure 
make && make install
# 2.安装编译依赖库
yum install -y gcc gcc-c++ gmp-devel mpfr-devel libmpc-devel bzip2
# 3.编译并安装gcc
tar -xvf gcc-9.2.0.tar.gz
cd gcc-9.2.0
./contrib/download_prerequisites
mkdir build
cd build
../configure --prefix=/usr/local/gcc-9.2.0 -enable-checking=release -enable-languages=c,c++ --disable-multilib
make -j 10 && make install
# 4.卸载已有的gcc和g++，设置环境变量
yum install -y gcc gcc-c++
export GCC_HOME=/usr/local/gcc-9.2.0
export PATH=$GCC_HOME/bin:$PATH
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

### rpm命令

```shell
rpm -ivh demo.rpm
#-i 安装包
#-v 显示正在安装的文件信息
#-h 显示正在安装的文件信息和安装进度
rpm -Uvh demo.rpm
#-U 升级包
rpm -e demo.rpm
#-e 卸载包
rpm -q < rpm package name>
```

### ln命令

```shell
#修改软链接 ln –snf [新的源文件或目录] [软链接文件]
#ln –snf  [新的源文件或目录]   [软链接文件]
#重新设置linux服务器时区，立刻生效
sudo ln -snf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
#删除软链接
rm -rf ./软链接名称
rm -rf ./软链接名称/ (这样就会把软链接以及软链接指向下的内容删除)
```

### rsync命令

```shell
rsync options source destination
-v : 详细模式输出
-r : 递归拷贝数据，但是传输数据时不保留时间戳和权限
-a : 归档模式, 归档模式总是递归拷贝，而且保留符号链接、权限、属主、属组时间戳
-z : 压缩传输
-h : human-readable
--progress： 显示传输过程
--exclude=PATTERN 指定排除传输的文件模式
--include=PATTERN 指定需要传输的文件模式
--delete 同步时，删除那些DST中有，而SRC没有的文件
--max-size：限定传输文件大小的上限
--dry-run：显示那些文件将被传输，并不会实际传输
--bwlimit：限制传输带宽
-W：拷贝文件，不进行增量检测
sudo yum -y install rsync
rsync -zavh ./init.sh  avalon@192.168.50.202:/home/avalon
```

### read命令

```shell
read 命令用于从标准输入读取数值。
read 内部命令被用来从标准输入读取单行数据。这个命令可以用来读取键盘输入，当使用重定向的时候，可以读取文件中的一行数据。
read [-ers] [-a aname] [-d delim] [-i text] [-n nchars] [-N nchars] [-p prompt] [-t timeout] [-u fd] [name ...]
参数说明:
-a 后跟一个变量，该变量会被认为是个数组，然后给其赋值，默认是以空格为分割符。
-d 后面跟一个标志符，其实只有其后的第一个字符有用，作为结束的标志。
-p 后面跟提示信息，即在输入前打印提示信息。
-e 在输入的时候可以使用命令补全功能。
-n 后跟一个数字，定义输入文本的长度，很实用。
-r 屏蔽\，如果没有该选项，则\作为一个转义字符，有的话 \就是个正常的字符了。
-s 安静模式，在输入字符时不再屏幕上显示，例如login时输入密码。
-t 后面跟秒数，定义输入字符的等待时间。
-u 后面跟fd，从文件描述符中读入，该文件描述符可以是exec新开启的。
```

### 硬件信息查看

```shell
# lscpu命令能够查看 CPU 和处理单元的信息。
lscpu
# lspci是另一个命令行工具，可以用来列出所有的 PCI 总线，还有与 PCI 总线相连的设备的详细信息，比如 VGA 适配器、显卡、网络适配器、usb 端口、SATA 控制器等。
lspci
# lshw是一个通用的工具，可以列出多种硬件单元的详细或者概要的信息，比如 CPU、内存、usb 控制器、硬盘等。lshw能够从各个“/proc”文件中提取出相关的信息。
lshw -short
# lsscsi通过运行下面的命令可以列出像硬盘和光驱等 scsi/sata 设备的信息：


```


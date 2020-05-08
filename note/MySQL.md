## 配置文件

``` shell
[client]
port=3306
socket=/tmp/mysql.sock

[mysqld]
port=3306
socket=/tmp/mysql.sock
language=/home/avalon/mysql/share/english
basedir=/home/avalon/mysql
datadir=/home/avalon/mysql/data
pid_file=/home/avalon/mysql/mysql.pid
bind_address=0.0.0.0
character_set_server=utf8mb4
collation_server=utf8mb4_unicode_ci
init_connect='set names utf8mb4'
skip-character-set-client-handshake=true
#-----------------------------------------日志设置-----------------------------------------
#错误日志
log_error=/home/avalon/mysql/logs/error.log
#慢查询日志
long_query_time=1 
slow_query_log=1
slow_query_log_file=/home/avalon/mysql/logs/mysql-slow.log
#一般查询日志
general_log=1
general_log_file=/home/avalon/mysql/logs/mysql-general.log
#-----------------------------------------基本设置-----------------------------------------
#设置默认时区
default_time_zone='+8:00'
#不区分大小写
lower_case_table_names=1
#0表示禁用缓存
query_cache_type=0
#设置Mysql的最大连接数
max-connections=100
#SQL语句MODE选择
# 1.STRICT_TRANS_TABLES
#   如果一个值不能插入到一个事务表中，则中断当前的操作，对非事务表不做限制
# 2.NO_ZERO_IN_DATE
#   不允许日期中的月和日包含0，支持0000-00-00 0000-01-01
# 3.NO_ZERO_DATE
#   年月日其中一项不为0即可，和NO_ZERO_IN_DATE结合才能完整过滤无意义的日期
# 4.ERROR_FOR_DIVISION_BY_ZERO
#   sql语句中如果出现被除数为0则报错，如果没有该模式，则返回null
# 5.NO_AUTO_CREATE_USER
#   禁止GRANT创建密码为空的用户
# 6.NO_ENGINE_SUBSTITUTION
#   如果需要的存储引擎被禁用或未编译，那么抛出错误。不设置此值时，用默认的存储引擎替代，并抛出一个异常
# 7.ONLY_FULL_GROUP_BY
#   对于GROUP BY聚合操作，如果在SELECT中的列，没有在GROUP BY中出现，那么这个SQL是不合法的
# 8.NO_AUTO_VALUE_ON_ZERO
#   默认设置下，插入0或NULL代表生成下一个自增长值，如果需要插入0还能保证自增长，添加该模式
# 9.PIPES_AS_CONCAT
#   将"||"视为字符串的连接操作符而非或运算符，这和Oracle数据库是一样的，也和字符串的拼接函数Concat相类似
# 10.ANSI_QUOTES
#   启用ANSI_QUOTES后，可以使用双引号来引用字符串
sql_mode=STRICT_TRANS_TABLES,NO_AUTO_VALUE_ON_ZERO,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,PIPES_AS_CONCAT,ANSI_QUOTES
#开启binlog，并指定对应文件
log_bin=mysql_bin
#MySQL的二进制日志（binary log）同步到磁盘的频率，取值0-N
#    0：当执行写入之后，MySQL不做fsync之类的磁盘同步指令刷新binlog_cache中的信息到磁盘，而让文件系统自行决定什么时候来做同步，或者cache满了之后才同步到磁盘。这个是性能最好的。
#    n：当每进行n次写入提交之后，MySQL将进行一次fsync之类的磁盘同步指令来将binlog_cache中的数据强制写入磁盘。
sync_binlog=1
#binlog文件格式，分别为statement、mixed、row
#    row（row-based replication）
#        binlog文件记录每行数据的每次修改，然后在slave端再对相同的数据进行修改。
#    statement（statement-based replication）
#        全部更新语句均被记录，减少了binlog日志量，节约IO，提高性能。
#    mixed（mixed-based replication）
#        混合使用，一般复制使用STATEMENT模式记录，对于STATEMENT模式无法复制的操作使用ROW模式
binlog_format=row
#binlog日志文件最大大小
max_binlog_size=1024M
#设置binlog过期时间，到期后使用新的binlog文件
expire_logs_days=30
#binlog缓存大小
binlog_cache_size=4M
#最大binlog缓存大小
max_binlog_cache_size=16M
#-----------------------------------------InnoDB引擎设置-----------------------------------------
#默认存储引擎
default-storage-engine=InnoDB
#InnoDB引擎缓存池，缓存索引、数据页、自适应哈希索引、插入缓存、锁、内部数据结构
innodb_buffer_pool_size=1024M
#额外内存 5.7之后移除
#innodb_additional_mem_pool_size=16M
#ib_logfile（ redo log和undo log）刷新方式，取值:0/1/2
#	0：表示每秒把log buffer刷到文件系统中(os buffer)去，并且调用文件系统的"flush"操作将缓存刷新到磁盘上去。也就是说一秒之前的日志都保存在日志缓冲区，也就是内存上，如果机器宕掉，可能丢失1秒的事务数据。
#	1：表示在每次事务提交的时候，都把log buffer刷到文件系统中(os buffer)去，并且调用文件系统的"flush"操作将缓存刷新到磁盘上去
#	2：表示在每次事务提交的时候会把log buffer刷到文件系统缓存中去，但并不会立即刷写到磁盘。
innodb_flush_log_at_trx_commit=0
#innodb数据文件打开模式
#	fdatasync：默认，调用fsync()去刷系统缓存数据文件与redo log的buffer
#	O_DSYNC：写入通过系统缓存，但是直接读取
#	O_DIRECT：不通过系统缓存，直接读写文件
innodb_flush_method=O_DIRECT
#日志缓存大小
innodb_log_buffer_size=2M
#日志文件大小
innodb_log_file_size=32M
#日志文件组数量
innodb_log_files_in_group=2
#最大脏页比例
innodb_max_dirty_pages_pct=90
#最大事物锁等待时间
innodb_lock_wait_timeout=10
#----------------------------------------mysql主从配置---------------------------------------
#表示是本机的序号为1,一般来讲就是master的意思
server_id=1
#从服务器是否记录relaylog中更新的数据至自身的binlog中
#log_slave_updates=1
#如果希望从库只读，开启该选项
#read_only=1
#主库IP
#master_host=192.168.50.201
#同步数据库的端口号
#master_port=3306
#具有同步权限的账户
#master_user=forCopy
#对应账号的密码
#master_password=asdfasdf
#目标同步binlog文件
#master_log_file=mysql_bin
#复制开始位置
#master_log_pos=120
#是否跳过自动复制，如果不是出现异常，从库的重启可以关闭该设置
#skip_slave_start=1
#指定relay log文件
#relay_log=slave_relay_bin
#开启relay恢复
#relay_log_recovery=1
```

## 安装启动

### 初始化

```shell
#mysql5.7初始化
./bin/mysqld --initialize --user=avalon --basedir=./ --datadir=./data
#MariaDB初始化，当前在mysql根目录
./scripts/mysql_install_db --user=avalon --basedir=./ --datadir=./data --skip-name-resolve
```

### 启动服务

```shell
#	--user	指定用户，表明生成的数据访问权限
#	nohup	 no hang up，忽视挂断信号
#	>/dev/null	指定标准输出路径
#	2>&1	异常输出重定向
#	&		后台启动
nohup /home/avalon/mysql/bin/mysqld --user=avalon --defaults-file=/home/avalon/mysql/my.cnf >/dev/null 2>&1 &
#MariaDB服务启动,--defaults-file参数需要在最前面，，当前在mysql根目录
nohup ./bin/mysqld --defaults-file=./my.cnf --user=avalon --basedir=./ --datadir=./data >/dev/null 2>&1 &
```

### 停止服务

```shell
#该root用户是mysql的root用户
./bin/mysqladmin -u root -p shutdown
```

### 用户登录

```shell
./bin/mysql -u root -p
```

### 修改密码

```shell
#user() 表示当前登录用户
alter user user() identified by "asdfasdf";
##MariaDB(10.2.29)初始化密码
update user set authentication_string=password('asdfasdf'),plugin='mysql_native_password' where user='root';
#记得更新
flush privileges;
```

### 创建用户

```shell
# %表示任意地址
drop user 'username'@'host';
create user avalon@'%' identified by 'asdfasdf';
```

### 用户授权

```shell
#语法
#	grant <privileges> on <databasename>.<tablename> to <username>@<host> with grant option;
#	revoke <privileges> on <databasename>.<tablename> to <username>@<host>;
#例如
grant all on *.* to avalon@192.168.50.201 with grant option;
grant all on *.* to avalon@'%' identified by 'asdfasdf' with grant option;
#
grant alter,create,delete,drop,index,insert,select,show databases,show view,update,lock tables,references on *.* to solitude@'%' with grant option;
#
set password for avalon@'%' = password('asdfasdf');
flush privileges;
update user set authentication_string=password('asdfasdf'),plugin='mysql_native_password' where user='avalon';
revoke super on *.* from avalon@'%';
flush privileges;
```

### 启动脚本

```shell
#!/bin/bash
date=`date '+%F %T'`
echo "当前时间:"${date}
pid=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
if [ $pid ];then
    echo "MySQL已启动，进程:"${pid}
else
    echo "MySQL未启动，准备启动..."
    /home/avalon/mysql/bin/mysqld --defaults-file=/home/avalon/mysql/my.cnf --user=avalon --basedir=/home/avalon/mysql/ --datadir=/home/avalon/mysql/data >/dev/null 2>&1 & 
    sleep 1
    pid2=$(ps -ef | grep mysqld | grep -v grep | awk '{print $2}')
    if [ ${pid2} ];then
        echo "MySQL启动成功，进程:"${pid2}
        exit 0
    else
        echo "MySQL启动失败！"
    fi
fi
exit 0
```

### 开机启动

```shell
1.centos系统可通过/etc/rc.d/rc.local执行开机脚本和命令
2.修改/etc/rc.d/rc.local权限 sudo chmod +x /etc/rc.d/rc.local
3.sudo vim /etc/rc.d/rc.local
末尾添加 sh /home/avalon/mysql/start.sh & //其中&表示后台运行
4.注意，启动时执行的脚本必须以exit 0结尾，表示程序正常执行完成并退出
```

## 主从备份

### 创建用户

```shell
MariaDB [mysql]> create user justCopy@'%' identified by 'asdfasdf';
Query OK, 0 rows affected (0.00 sec)

MariaDB [mysql]> grant replication slave,replication client on *.* to 'justCopy'@'%';
Query OK, 0 rows affected (0.00 sec)

MariaDB [mysql]> update user set authentication_string=password('asdfasdf'),plugin='mysql_native_password' where user='justCopy';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [mysql]> flush privileges;
Query OK, 0 rows affected (0.01 sec)
```

### 备份主库

``` shell
#对主库上所有表加锁，不能执行UPDATA，DELETE，INSERT语句
mysql> flush tables with read lock;
#mysqldump进行主库的备份
#	--master-data=1：默认值，mysqldump出来的文件包括CHANGE MASTER TO这个语句，CHANGE MASTER TO后面紧接着就是file和position的记录，在slave上导入数据时就会执行
#	--master-data=2：mysqldump出来的文件也包括CHANGE MASTER TO这个语句，但是语句是被注释状态
#	--all-databases：备份全部表
[avalon@localhost mysql]$ ./bin/mysqldump --all-databases --flush-logs --master-data=1  -uroot -pasdfasdf  > /home/avalon/backup/backup.sql
#主库数据备份完毕后，释放锁
mysql> unlock tables;
```

### 从库导入

```shell
#复制文件至从库服务器
[avalon@localhost mysql]$ scp ../backup/backup.sql avalon@192.168.50.202:/home/avalon/backup/
#导入备份文件
mysql> source /home/avalon/backup/backup.sql中的binlog信息设置从库备份设置

```

### 开启备份

```shell
#查看主库binlog信息，file表示当前日志文件名称，position表示当前日志的位置
#通过backup.sql中的binlog信息设置从库备份起点，'mysql_bin.000006', MASTER_LOG_POS=385
mysql> CHANGE MASTER TO MASTER_HOST='192.168.50.201', MASTER_PORT=3306, MASTER_USER='justCopy', MASTER_PASSWORD='asdfasdf', MASTER_LOG_FILE='mysql_bin.000008', MASTER_LOG_POS=385;
#启动复制进程
mysql> start slave;
#查看从库状态
mysql> SHOW SLAVE STATUS\G
#如下信息表示从库备份正常，否则存在异常
#	Slave_IO_Running: Yes
#	Slave_SQL_Running: Yes
#停止复制进程
mysql> stop slave;
```

## 读写分离

### Maxscale配置

```shell
[maxscale]
threads=auto
ms_timestamp=1
syslog=1
maxlog=1
log_warning=1
log_notice=1
log_info=1
log_debug=1
log_augmentation=1
logdir=/home/avalon/maxscale/logs/
datadir=/home/avalon/maxscale/data/
cachedir=/home/avalon/maxscale/cache/
piddir=/home/avalon/maxscale/tmp/


[server1]
type=server
address=192.168.50.201
port=3306
protocol=MariaDBBackend
serv_weight=1
[server2]
type=server
address=192.168.50.203
port=3306
protocol=MariaDBBackend
serv_weight=1


[MariaDB-Monitor]
type=monitor
module=mariadbmon
servers=server1,server2
user=avalon
password=asdfasdf
monitor_interval=2000
detect_stale_master=true


[Read-Only-Service]
type=service
router=readconnroute
servers=server2
user=avalon
password=asdfasdf
router_options=slave
enable_root_user=1
weightby=serv_weight


[Read-Write-Service]
type=service
router=readwritesplit
servers=server1
user=avalon
password=asdfasdf
max_slave_connections=100%
use_sql_variables_in=master
enable_root_user=1
max_slave_replication_lag=3600


[MaxAdmin-Service]
type=service
router=cli


[Read-Only-Listener]
type=listener
service=Read-Only-Service
protocol=MariaDBClient
port=4008


[Read-Write-Listener]
type=listener
service=Read-Write-Service
protocol=MariaDBClient
port=4006


[MaxAdmin-Listener]
type=listener
service=MaxAdmin-Service
protocol=maxscaled
socket=/home/avalon/maxscale/tmp/maxscale.sock
```

### 启动服务

``` shell
#不能在root用户下启动maxscale
[avalon@localhost tmp]$ /usr/bin/maxscale -f /etc/maxscale.cnf
#添加linux用户avalon至信任列表
[avalon@localhost tmp]$  sudo /usr/bin/maxadmin enable account avalon -S /home/avalon/maxscale/tmp/maxscale.sock
#使用avalon用户登陆客户端
[avalon@localhost tmp]$ /usr/bin/maxadmin -S /home/avalon/maxscale/tmp/maxscale.sock
#查看数据库服务器列表
MaxScale> list servers
Servers.
-------------------+-----------------+-------+-------------+--------------------
Server             | Address         | Port  | Connections | Status              
-------------------+-----------------+-------+-------------+--------------------
server1            | 192.168.50.201  |  3306 |           2 | Master, Running
server2            | 192.168.50.202  |  3306 |           2 | Slave, Running
-------------------+-----------------+-------+-------------+--------------------
#查看路由服务列表
MaxScale> list services
Services.
--------------------------+-------------------+--------+----------------+-------------------
Service Name              | Router Module     | #Users | Total Sessions | Backend databases
--------------------------+-------------------+--------+----------------+-------------------
MaxAdmin-Service          | cli               |      1 |              4 | 
Read-Write-Service        | readwritesplit    |      2 |              3 | server1, server2
--------------------------+-------------------+--------+----------------+-------------------
#登陆mysql,将maxscale当作普通mysql服务器使用
mysql  -uavalon -p -h192.168.50.203 -P4006
```

### 自动启动

```shell
#!/bin/bash
/usr/bin/maxscale -f /etc/maxscale.cnf

#切换用户执行启动脚本
sudo vim /etc/rc.d/rc.local
su - avalon -c 'sh /home/avalon/maxscale/start.sh &'
```

## 常用操作

### 创建数据库

```sql
create database iris default character set utf8mb4 collate utf8mb4_unicode_ci;
```

### 创建表

```sql
CREATE TABLE IF NOT EXISTS `user`(
   `id` BIGINT UNSIGNED NOT NULL,
   `name` VARCHAR(32) NOT NULL,
   `age` INT(3) NOT NULL,
   `mobile` VARCHAR(16) NOT NULL,
   PRIMARY KEY ( `id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 collate utf8mb4_unicode_ci;
```

### 查看表结构

```sql
MariaDB [iris]> desc user;
+--------+---------------------+------+-----+---------+-------+
| Field  | Type                | Null | Key | Default | Extra |
+--------+---------------------+------+-----+---------+-------+
| id     | bigint(20) unsigned | NO   | PRI | NULL    |       |
| name   | varchar(32)         | NO   |     | NULL    |       |
| age    | int(3)              | NO   |     | NULL    |       |
| mobile | varchar(16)         | NO   |     | NULL    |       |
+--------+---------------------+------+-----+---------+-------+
```

## 问题

1.MVCC多版本并发控制

2.binlog，redolog，undolog都是什么，起什么作用

3.innodb的行锁和表锁

4.索引B+树的叶子节点可以存放哪些东西

5.查询在什么时候不走预期索引

6.sql优化

7.explain如何解析sql

8.order by原理
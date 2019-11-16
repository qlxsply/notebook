## 配置文件

``` shell
[client]
port=3306
socket=/tmp/mysql.sock

[mysqld]
port=3306
socket=/tmp/mysql.sock
basedir=/home/avalon/mysql
datadir=/home/avalon/mysql/data
pid_file=/home/avalon/mysql/mysql.pid
bind_address=0.0.0.0
character_set_server=utf8mb4
collation_server=utf8mb4-general-ci
init_connect='set names utf8mb4'
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
#   启用ANSI_QUOTES后，不能用双引号来引用字符串，因为它被解释为识别符
sql_mode=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_VALUE_ON_ZERO,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,PIPES_AS_CONCAT,ANSI_QUOTES
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
#额外内存
innodb_additional_mem_pool=16M
#ib_logfile（ redo log和undo log）刷新方式，取值:0/1/2
#	0：表示每秒把log buffer刷到文件系统中(os buffer)去，并且调用文件系统的"flush"操作将缓存刷新到磁盘上去。也就是说一秒之前的日志都保存在日志缓冲区，也就是内存上，如果机器宕掉，可能丢失1秒的事务数据。
#	1：表示在每次事务提交的时候，都把log buffer刷到文件系统中(os buffer)去，并且调用文件系统的"flush"操作将缓存刷新到磁盘上去
#	2：表示在每次事务提交的时候会把log buffer刷到文件系统缓存中去，但并不会立即刷写到磁盘。
innodb_flush_log_at_trx_commit=0
#innodb数据文件打开模式
#	fdatasync：默认，调用fsync()去刷系统缓存数据文件与redo log的buffer
#	O_DSYNC：写入通过系统缓存，但是直接读取
#	O_DIRECT：不通过系统缓存，直接读写文件
innodb_flush_method=fdatasync
#日志缓存大小
innodb_log_buffer_size=2M
#日志文件大小
innodb_log_file_size=32M
#日志文件组数量
innodb_log_files_in_group=2
#最大脏页比例
innodb_max_dirty_pages_pct=90
#最大事物锁等待时间
innodb_lock_wait_timeout=120
#----------------------------------------mysql主从配置---------------------------------------
#表示是本机的序号为1,一般来讲就是master的意思
server_id=1
#从服务器是否记录relaylog中更新的数据至自身的binlog中
log_slave_updates=1
#如果希望从库只读，开启该选项
#read_only=1
#主库IP
master_host=192.168.50.201
#同步数据库的端口号
master_port=3306
#具有同步权限的账户
master_user=forCopy
#对应账号的密码
master_password=123456
#是否跳过自动复制
skip-slave-start=1

```

## 安装启动

### 初始化

```shell
#记住随机密码
/home/avalon/mysql/bin/mysqld --initialize --user=avalon --basedir=/home/avalon/mysql --datadir=/home/avalon/mysql/data
```

### 启动服务

```shell
#	--user	指定用户，表明生成的数据访问权限
#	nohup	 no hang up，忽视挂断信号
#	>/dev/null	指定标准输出路径
#	2>&1	异常输出重定向
#	&		后台启动
nohup /home/avalon/mysql/bin/mysqld --user=avalon --defaults-file=/home/avalon/mysql/my.cnf >/dev/null 2>&1 &

```

### 停止服务

```shell
/home/avalon/mysql/bin//mysqladmin -u avalon -p shutdown
```

### 登录

```shell
/home/avalon/mysql/bin/mysql -u root -p
```

### 修改密码

```shell
#user() 表示当前登录用户
alter user user() identified by "asdfasdf";
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
grant all on *.* to avalon@'%' with grant option;
set password for avalon@'%' = password('asdfasdf');
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
    /home/avalon/mysql/bin/mysqld --defaults-file=/home/avalon/mysql/my.cnf --user=avalon >/dev/null 2>&1 & 
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
2.修改/etc/rc.d/rc.local权限 chmod +x /etc/rc.d/rc.local
3.vim /etc/rc.d/rc.local
末尾添加 sh /home/avalon/bash/mysql-start.sh & //其中&表示后台运行
4.注意，启动时执行的脚本必须以exit 0结尾，表示程序正常执行完成并退出
```


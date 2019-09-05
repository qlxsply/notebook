# MySQL

## innodb_flush_log_at_trx_commit 和 sync_binlog

```
innodb_flush_log_at_trx_commit 和 sync_binlog 是 MySQL 的两个配置参数。它们的配置对于 MySQL 的性能有很大影响（一般为了保证数据的不丢失，会设置为双1，该情形下数据库的性能也是最低的）。
```



### innodb_flush_log_at_trx_commit

```
InnoDB 引擎特有的，ib_logfile的刷新方式（ ib_logfile：记录的是redo log和undo log的信息）
取值:0/1/2
innodb_flush_log_at_trx_commit=0，表示每隔一秒把log buffer刷到文件系统中(os buffer)去，并且调用文件系统的“flush”操作将缓存刷新到磁盘上去。也就是说一秒之前的日志都保存在日志缓冲区，也就是内存上，如果机器宕掉，可能丢失1秒的事务数据。

innodb_flush_log_at_trx_commit=1，表示在每次事务提交的时候，都把log buffer刷到文件系统中(os buffer)去，并且调用文件系统的“flush”操作将缓存刷新到磁盘上去。这样的话，数据库对IO的要求就非常高了，如果底层的硬件提供的IOPS比较差，那么MySQL数据库的并发很快就会由于硬件IO的问题而无法提升。

innodb_flush_log_at_trx_commit=2，表示在每次事务提交的时候会把log buffer刷到文件系统中去，但并不会立即刷写到磁盘。如果只是MySQL数据库挂掉了，由于文件系统没有问题，那么对应的事务数据并没有丢失。只有在数据库所在的主机操作系统损坏或者突然掉电的情况下，数据库的事务数据可能丢失1秒之类的事务数据。这样的好处，减少了事务数据丢失的概率，而对底层硬件的IO要求也没有那么高(log buffer写到文件系统中，一般只是从log buffer的内存转移的文件系统的内存缓存中，对底层IO没有压力)。

3）如果innodb_flush_log_at_trx_commit设置为2，每次事务提交时MySQL都会把log buffer的数据写入log file.但是flush(刷到磁盘)操作并不会同时进行。该模式下,MySQL会每秒执行一次 flush(刷到磁盘)操作。
```

### sync_binlog

```
sync_binlog：是MySQL 的二进制日志（binary log）同步到磁盘的频率。

取值：0-N
sync_binlog=0，当事务提交之后，MySQL不做fsync之类的磁盘同步指令刷新binlog_cache中的信息到磁盘，而让Filesystem自行决定什么时候来做同步，或者cache满了之后才同步到磁盘。这个是性能最好的。

sync_binlog=1，当每进行1次事务提交之后，MySQL将进行一次fsync之类的磁盘同步指令来将binlog_cache中的数据强制写入磁盘。

sync_binlog=n，当每进行n次事务提交之后，MySQL将进行一次fsync之类的磁盘同步指令来将binlog_cache中的数据强制写入磁盘。

注：
大多数情况下，对数据的一致性并没有很严格的要求，所以并不会把 sync_binlog 配置成 1. 为了追求高并发，提升性能，可以设置为 100 或直接用 0.
而和 innodb_flush_log_at_trx_commit 一样，对于支付服务这样的应用，还是比较推荐 sync_binlog = 1.
```

```
max-connections = 320：设置Mysql的最大连接数；如果实际应用中，并发的连接数量比较大，可以适当的调高此参数，但是，也不是说越高越好，因为这牵涉到服务器的机器硬件的性能。
```

```
query_cache_type = 1：设置缓存的类型，有以下几种设置方法：

设置成0，表示禁用缓存；设置成1，表示缓存所有结果；设置成2，表示只缓存在select语句中通过SQL_CACHE指定需要缓存的查询；
```


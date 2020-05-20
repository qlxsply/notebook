## Netty模型

1.netty抽象出两组线程池，其中BossGroup负责接收客户端的链接，WorkerGroup负责网络的读写。

2.BossGroup和WorkerGroup类型都是NioEventLoopGroup

3.NioEventLoopGroup相当于一个事件循环组，这个组中含有多个事件循环，每个事件循环是NioEventLoop

4.NioEventLoop表示一个不断循环的执行处理任务的线程，每个NioEventLoop都有一个selector，用于监听绑定在其上的socket网络通讯。

5.NioEventLoopGroup内部可以有多个线程，即内部可以含有多个NioEventLoop。

6.每个BossNioEventLoop执行的步骤：

```shell
1.轮询accept事件
2.处理accept事件，与client建立连接，生成NioSocketChannel，并将其注册到某个Worker NioEventLoop上的selector
3.处理任务队列的任务，即runAllTasks
```

7.每个Worker NioEventLoop循环执行的步骤：

```shell
1.轮询read、write事件
2.处理I/O事件，即read、write事件，在对应NioSocketChannel处理
3.处理任务队列的任务，即runAllTasks
```

8.每个Worker NioEventLoop处理任务时，会使用pipeline（管道），pipeline中包含了channel，即通过pipeline可以获取对应的通道，管道内维护了很多的处理器。

 

 
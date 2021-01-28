# Java笔记

## 线程间的通信方式

### suspend和resume

suspend：让线程挂起，暂停，程序停止往下执行

resume：唤醒被suspend的程序，让线程继续执行

缺陷：当线程A使用锁L，如果线程A处于suspend状态，而另一个线程B，需要L这把锁才能resume线程A，因为线程A处理suspend状态，是不会释放L锁，所以线程B线获取不到这个锁，而一直处于争夺L锁的状态，最终导致死锁。

### park和unpark

LockSupport.park()：暂停当前线程

LockSupport.unpark：恢复某个线程的运行

与wait/notify比较：

- wait，notify和notifyAll必须配合Object Monitor一起使用，而unpark不必
- park & unpark是以线程为单位来【阻塞】和【唤醒】线程，而notify只能随机唤醒一个等待线程，notifyAll是唤醒所有等待线程，就不那么【精确】
- park & unpark可以先unpark，而wait & notify不能先notify



1.高并发HashMap的环如何产生

2.线程之间如何通讯

3.Boolean占几个字节

4.Exception和Error

5.各类垃圾回收器的特点与区别

6.双亲委派模型

7.JDBC和双亲委派模型

8.Minor GC和Full GC触发条件

9.运行时数据区域和内存模型

10.垃圾回收机制和回收算法

## 垃圾收集器

1.如果应用程序有一个小的内存空间（最高达100MB），则使用选项-XX:+UseSerialGC选择串行垃圾收集器
2.如果应用程序运行在一个单核处理器上，并且没有暂停时间需求，则使用-XX:+UseSerialGC
3.如果峰值应用程序性能是第一优先级，并且没有暂停时间要求，或者可以接受一秒甚至更长时间暂停，让虚拟机选择垃圾收集器或者使用选项-XX:+UseParallelGC。
4.如果响应时间比整体吞吐量更重要，垃圾收集停顿必须保持小于一秒钟，然后选择一个主要的并发垃圾收集器使用选项-XX:+UseG1GC或者-XX:+UseConcMarkSweepGC。
5.如果响应时间是一个高优先级，并且可以使用一个非常大的堆，那么使用-XX:UseZGC？？选择一个完全并发的收集器
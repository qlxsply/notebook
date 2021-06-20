# Java笔记

## 基本数据类型

### byte

1字节8位，有符号，以二进制补码表示的整数，默认0

### short

2字节16位，有符号，以二进制补码表示的整数，默认0

### int

4字节32位

### long

8字节64位

### float

4字节32位

### double

8字节64位

### boolean

对于boolean类型，编译后使用int数据类型代替存储，为4字节32位。对于boolean数组类型，编译后使用byte数组代替，每个boolean元素占8位。

### char

2字节16位，char 数据类型可以储存任何字符

## Collection

### Map

#### HashMap

​		HashMap底层通过数组+链表/红黑树实现，根据key的hashcode进行存储，根据key获取对应的value值，元素无序存储，允许一条记录的key为null，允许value为空。线程不安全。可通过Collections.synchronizedMap方法获取线程安全的Map实例，通过全局加锁的方式保证同时只有一个线程在操作Map实例。

#### Hashtable

#### LinkedHashMap

#### TreeMap

Hashtable与 HashMap类似,它继承自Dictionary类，不同的是:它不允许记录的键或者值为空;它支持线程的同步，即任一时刻只有一个线程能写Hashtable,因此也导致了 Hashtable在写入时会比较慢。

LinkedHashMap 是HashMap的一个子类，保存了记录的插入顺序，在用Iterator遍历LinkedHashMap时，先得到的记录肯定是先插入的.也可以在构造时用带参数，按照应用次数排序。在遍历的时候会比HashMap慢，不过有种情况例外，当HashMap容量很大，实际数据较少时，遍历起来可能会比 LinkedHashMap慢，因为LinkedHashMap的遍历速度只和实际数据有关，和容量无关，而HashMap的遍历速度和他的容量有关。

TreeMap实现SortMap接口，能够把它保存的记录根据键排序,默认是按键值的升序排序，也可以指定排序的比较器，当用Iterator 遍历TreeMap时，得到的记录是排过序的。

一般情况下，我们用的最多的是HashMap，在Map 中插入、删除和定位元素，HashMap 是最好的选择。但如果您要按自然顺序或自定义顺序遍历键，那么TreeMap会更好。如果需要输出的顺序和输入的相同,那么用LinkedHashMap 可以实现,它还可以按读取顺序来排列。

HashMap是一个最常用的Map，它根据键的hashCode值存储数据，根据键可以直接获取它的值，具有很快的访问速度。HashMap最多只允许一条记录的键为NULL，允许多条记录的值为NULL。

HashMap不支持线程同步，即任一时刻可以有多个线程同时写HashMap，可能会导致数据的不一致性。如果需要同步，可以用Collections的synchronizedMap方法使HashMap具有同步的能力。

Hashtable与HashMap类似，不同的是：它不允许记录的键或者值为空；它支持线程的同步，即任一时刻只有一个线程能写Hashtable，因此也导致了Hashtable在写入时会比较慢。

LinkedHashMap保存了记录的插入顺序，在用Iterator遍历LinkedHashMap时，先得到的记录肯定是先插入的。

在遍历的时候会比HashMap慢TreeMap能够把它保存的记录根据键排序，默认是按升序排序，也可以指定排序的比较器。当用Iterator遍历TreeMap时，得到的记录是排过序的。

## Concurrent

### Striped64

​		Striped64是一个高并发累加的工具类。Striped64的核心设计思路是通过内部的分散计算来避免竞争。Striped64内部包含一个base和一个Cell[] cells数组。
​		没有竞争的情况下，要累加的数通过cas累加到base上；如果有竞争的话，会将要累加的数累加到Cells数组中的某个cell元素里面。所以整个Striped64的值为sum=base+∑[0~n]cells。
​		在没有竞争的情况下不会使用cells数组，只是用base做累加。有了竞争后才使用cells数组累加，第一次初始化长度为2，以后每次扩容都是变为原来的两倍，直到cells数组的长度大于等于当前服务器cpu的数量为止就不在扩容，每个线程会通过线程对cells[threadLocalRandomProbe%cells.length]位置的Cell对象中的value做累加，这样相当于将线程绑定到了cells中的某个cell对象上。

### LongAdder与AtomicLong 

​		AtomicLong通过CAS提供非阻塞的原子性操作，但是在高并发情况下，容易导致大量线程CAS失败进而处于自旋状态，照成CPU资源浪费。
​		对于AtomicLong性能问题是由于过多线程同时去竞争同一个变量的更新而降低的，那么LongAdder就将一个变量分解为多个变量，让线程去竞争多个资源。

### AtomicReference与AtomicStampedReference

​		AtomicReference通过volatile和Unsafe提供的CAS函数实现原子操作。 自旋+CAS的无锁操作保证共享变量的线程安全。AtomicReference中的value是volatile类型，这保证了当某线程修改value的值时，其他线程看到的value的值都是最新的值。但是AtomicReference存在ABA问题。
​		AtomicStampedReference通过对value增加版本号的方式避免了ABA问题。


## 嵌套类

### 静态嵌套类  Static Nested Class

​		静态嵌套类与外部类的关联关系类似于类的方法和属性，也和类的静态方法一样，不能直接访问外部类的实例属性和方法，只能通过对象引用访问。

### 内部类  Inner Class

​		类似于对象的方法和属性，内部类和外部类的一个实例相关联并且可以直接访问对象的方法和属性，但同时也导致内部类不能定义静态成员。

​		内部类的实例必须依赖于外部类的实例而存在。

### 为什么要使用内部类？

1. 对于只在某一个地方使用的类进行逻辑分组
2. 更好的封装属性，例如内部类可以直接访问外部类属性，则外部类可以将仅供内部类使用的属性声明为private，而且内部类也可以对外隐藏
3. 增加代码可读性和可维护性

## 泛型

​		Java采用类型擦除机制来实现泛型，Java中的泛型仅仅在编译时有效，确保数据的安全性和免去强制类型转换。

### ParameterizedType

​		参数化类型，相当于泛型的实例，例如Collection\<String>，不是Collection\<E>

###  TypeVariable

​		类型变量或者泛型变量，相当于Collection\<E>和Map<K,V>中的E，K和V

### GenericDeclaration

​		可以声明范型变量的实体，只有实现了该接口的“实体”才能声明“类型变量”，目前有Class，Constructor，Method实现了该接口，也就是只有类、构造函数、方法上可以使用泛型

### GenericArrayType

​		泛型数组，GenericArrayType表示其组件类型为参数化类型（ParameterizedType）或类型变量（TypeVariable）的数组类型

### WildcardType

​		WildcardType表示通配符类型表达式，例如? ，? extends Number ? extends Number还是? super Integer ? super Integer

### 为何不支持泛型数组？

​		由于泛型的类型擦除机制和数组对象的共变性，如果允许泛型数组将破坏java语法提供的类型安全，例如：

```java
// Not really allowed.
List<String>[] lsa = new List<String>[10];
Object o = lsa;
Object[] oa = (Object[]) o;
List<Integer> li = new ArrayList<Integer>();
li.add(new Integer(3));
// Unsound, but passes run time store check
oa[1] = li;
// Run-time error: ClassCastException.
String s = lsa[1].get(0);
```

​		但是，允许无限界的通配符类型数组，例如：

```java
// OK, array of unbounded wildcard type.
List<?>[] lsa = new List<?>[10];
Object o = lsa;
Object[] oa = (Object[]) o;
List<Integer> li = new ArrayList<Integer>();
li.add(new Integer(3));
// Correct.
oa[1] = li;
// Run time error, but cast is explicit.
String s = (String) lsa[1].get(0);
```

## 进程与线程

```
https://docs.oracle.com/javase/tutorial/essential/concurrency/procthread.html
```



## 线程间的通信方式

### suspend和resume

suspend：让线程挂起，暂停，程序停止往下执行

resume：唤醒被suspend的程序，让线程继续执行

缺陷：当线程A使用锁L，如果线程A处于suspend状态，而另一个线程B，需要L这把锁才能resume线程A，因为线程A处理suspend状态，是不会释放L锁，所以线程B线获取不到这个锁，而一直处于争夺L锁的状态，最终导致死锁。

### park和unpark

LockSupport.park()：暂停当前线程

LockSupport.unpark：恢复某个线程的运行

### 与wait/notify比较

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

## 常见概念

### 常量折叠

在编译优化时，多个变量进行计算时，而且能够直接计算出结果，那么变量将由常量直接替换

```java
int a = 1;
int b = 2;
int c = a + b;//会被直接优化成 int c = 3;
```

### 常量传播

在编译优化时，将能够计算出结果的变量直接替换为常量

```java
int a = 1;
System.out.println(a);//会被直接优化成 System.out.println(1);
```

## JMH

### @BenchmarkMode

用来配置Mode选项，可用于类或者方法上，这个注解的value是一个数组，可以把几种Mode集合在一起执行。

#### Mode.Throughput

整体吞吐量，每秒执行了多少次调用，单位为 `ops/time`

#### Mode.AverageTime

用的平均时间，每次操作的平均时间，单位为 `time/op`

#### Mode.SampleTime

随机取样，最后输出取样结果的分布

#### Mode.SingleShotTime

只运行一次，往往同时把Warmup次数设为 0，用于测试冷启动时的性能

#### Mode.All

上述所有模式执行一次

### @State

通过 State 可以指定一个对象的作用范围，JMH 根据 scope 来进行实例化和共享操作。@State 可以被继承使用，如果父类定义了该注解，子类则无需定义。由于 JMH 允许多线程同时执行测试，不同的选项含义如下：

1. Scope.Benchmark：所有测试线程共享一个实例，测试有状态实例在多线程共享下的性能
2. Scope.Group：同一个线程在同一个 group 里共享实例
3. Scope.Thread：默认的 State，每个测试线程分配一个实例

### @OutputTimeUnit

设置统计结果的时间单位，可用于类或者方法注解

### @Warmup

预热所需要配置的一些基本测试参数，可用于类或者方法上。一般前几次进行程序测试的时候都会比较慢，所以要让程序进行几轮预热，保证测试的准确性。参数如下所示：
1. iterations：预热的次数
2. time：每次预热的时间
3. timeUnit：时间的单位，默认秒
4. batchSize：批处理大小，每次操作调用几次方法

为什么需要进行预热？
因为 JVM 的 JIT 机制的存在，如果某个函数被调用多次之后，JVM 会尝试将其编译为机器码，从而提高执行速度，所以为了让 benchmark 的结果更加接近真实情况就需要进行预热。

### @Measurement

实际调用方法所需要配置的一些基本测试参数，可用于类或者方法上，参数和 `@Warmup` 相同。

### @Threads

设置测试运行的默认线程数量，可用于类或者方法上。

### @Fork

为基准设置默认的分叉参数，可用于类或者方法上。

### @Param

标记基准中的可配置参数。
Param修饰的字段应该是非final字段，并且应该只驻留在@State修饰的类中。JMH 会在调用任何Setup方法之前将值注入带注释的字段。 不保证可以在State任何初始化程序或任何构造函数中访问字段值。
参数可以是基础数据类型、基础数据类型的包装类，String或者枚举类，注释值通过String类型设置，再强制转换成对应的值。
参数通常应该提供默认值，即使没有为运行设置显式参数，也可以使基准测试运行。 唯一的例外是枚举类型，它将隐式设置包含所有枚举常量的默认值。

### JMH陷阱

1.JIT优化的死码消除，例如：

```java
//JVM会认为代码中的a从来没有被使用过，从而将整块代码优化掉
//可通过返回变量a来避免被优化
public void testStringAdd(Blackhole blackhole) {
    String a = "";
    for (int i = 0; i < length; i++) {
        a += i;
    }
}
```

## XML

#### xmlns

​		XML Name Space，XML命名空间就是标签的前缀，没有前缀的标签，使用的是默认的命名空间。命名空间是用来解决标签命名冲突的。标签命名空间语法 = xmlns + : + 标签名
​		每一个命名空间都需要有一个 xsd （XML Schema Definition）文件与之对应，xsd 文件规定了 XML 中使用的标签的名字，以及各种标签的嵌套关系、标签的书写规则、语法。

#### xmlns:xsi

​		xmlns:xsi定义了以 xsi 开头的命名空间。如果值为http://www.w3.org/2001/XMLSchema-instance，该命名空间就可以在任何XML文件中直接使用，而无需指定 xsd 文件。
​		xmlns:xsi是标准核心命名空间之一。

#### xsi:schemaLocation

​		该命名空间下的 schemaLocation 属性定义了：http://www.w3.org/2001/XMLSchema-instance 命名空间外的其它命名空间与其 xsd 文件的位置。
​		格式为（如果存在多个命名空间，可以有多行）：命名空间 命名空间的xsd文件

```xml
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:html="http://www.w3.org/1999/xhtml"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.w3.org/1999/XSL/Transform
                                http://www.w3.org/1999/XSL/Transform.xsd
                                http://www.w3.org/1999/xhtml
                                http://www.w3.org/1999/xhtml.xsd">
```

## Gradle

### Gradle Wrapper

​		不同的项目可能需要使用不同版本的gradle进行构建，使用Gradle Wrapper便于统一gradle构建的版本。

wrapper生成方法：

​		1.项目路径下创建settings.gradle文件

​		2.项目根路径下执行gradle wrapper命令

​		3.生成文件如下

```
|____gradle
| |____wrapper
| | |____gradle-wrapper.jar				//具体业务逻辑
| | |____gradle-wrapper.properties		//配置文件
|____gradlew						//Linux 下可执行脚本
|____gradlew.bat					//Windows 下可执行脚本
|____settings.gradle				//
```

### gradle-wrapper.properties

distributionBase + distributionPath

指定gradle解压包所在路径

zipStoreBase + zipStorePath

指定被下载的gradle压缩包所在路径

distributionUrl

指定gradle版本和下载地址

```properties
# GRADLE_USER_HOME 表示用户目录
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-3.1-bin.zip
```

### build.gradle

​		项目构建设置，类似于pom.xml

### settings.gradle

​		放在根工程目录下，用于初始化工程，

### 依赖方式

#### implementation

​		依赖库在编译时期只对当前的module可见，对其他的module不可见，但是在运行时其是可见的，这种方式的好处是可以显著减少build项目的时间，因为假如该依赖库有接口或者代码变动，那么Gradle只会去重新编译和它有直接依赖关系的module，也就是该库不存在传递性。

#### api

​		在编译时期和运行时期都可以对其他module可见。

#### compileOnly

​		只在编译时有效，不参与打包

#### runtimeOnly

​		只在打包的时候有效，编译不参与

### 构建步骤

#### 初始化

​		

#### 配置

#### 执行

### 操作

#### 刷新依赖

​		gradlew build --refresh-dependencies

## Maven

### maven内置属性

#### ${basedir}

项目根目录（包含pom.xml文件的目录）

#### ${version}

项目版本

### POM属性

#### ${project.build.sourceDirectory}

项目的主源码目录，默认为 src/main/java

#### ${project.build.testSourceDirectory}

项目的测试源码目录，默认为 src/test/java

#### ${project.build.directory}

项目构件输出目录，默认为 target/

#### ${project.build.outputDirectory}

项目主代码编译输出目录，默认为 target/classes/

#### ${project.build.scriptSourceDirectory}

项目的脚本目录，默认为src/main/scripts

#### ${project.build.testOutputDirectory}

项目测试代码编译输出目录，默认为 target/test-classes/

#### ${project.build.finalName}

项目打包输出文件的名称，默认为"${project.artifactId} - ${project.version}"

#### ${project.groupId}

项目的 groupId

#### ${project.artifactId}

项目的 artifactId

#### ${project.version}

项目的 version，与${version}等价

### Java系统属性

#### user.home

用户的主目录

#### user.dir

用户的当前工作目录

### 构建设置\<build>

```xml
<resources>
    <resource>
        <targetPath>conf</targetPath>
        <filtering>false</filtering>
        <directory>${basedir}/src/main/resources</directory>
        <includes>
            <include>**/*.xml</include>
        </includes>
        <excludes>
            <exclude>**/*.properties</exclude>
        </excludes>
    </resource>
</resources>
```

#### targetPath

​		打包资源文件的目的地址

#### filtering

​		配合\<filter>标签一起使用，是否使用属性文件中的属性值替换pom文件中的占位符

#### directory

​		资源文件所在路径，相对于pom文件而言

#### includes

​		包含的模式列表，例如**/*.xml

#### excludes

​		排除的模式列表，例如**/*.xml
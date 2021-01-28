## GCC

```shell
gcc -o hello hello.c -I /home/hello/include -L /home/hello/lib -lworld

# 参数说明：
# -I /home/hello/include表示将/home/hello/include目录作为第一个寻找头文件的目录，寻找的顺序是：/home/hello/include-->/usr/include-->/usr/local/include

# -L /home/hello/lib表示将/home/hello/lib目录作为第一个寻找库文件的目录，寻找的顺序是：/home/hello/lib-->/lib-->/usr/lib-->/usr/local/lib

# -l -lworld表示在上面的lib的路径中寻找libworld.so动态库文件（如果gcc编译选项中加入了“-static”表示寻找libworld.a静态库文件），程序链接的库名是world
```


## 远程开发设置

1.生成本地ssh秘钥对

ssh-keygen -t rsa -b 4096
```
-t: 指定密钥的类型，密钥的类型有两种，一种是RSA，一种是DSA。默认使用rsa密钥，所以不加-t rsa也行，如果你想生成dsa密钥，就需要加参数-t dsa

-b: 指定密钥长度。对于RSA密钥，最小要求768位，默认是2048位。命令中的4096指的是RSA密钥长度为4096位。DSA密钥必须恰好是1024位(FIPS 186-2 标准的要求)。
```

2.添加本地公钥id_rsa.pub至远程主机用户目录下.ssh文件夹内的authorized_keys文件中

ssh-copy-id avalon@8.129.213.168

3.安装插件Remote Development进行远程连接

## Java代码开发设置

### 格式化设置

```json
{
    //设置格式化所用配置文件地址
    "java.format.settings.url": "/home/avalon/.vscode-server/extensions/redhat.java-0.70.0/formatters/eclipse-formatter.xml"
}
```

### 快捷键

#### 自动导入

`Shift+Alt+O` 自动导入包


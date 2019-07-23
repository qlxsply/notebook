## 1.ubuntu安装Chrome浏览器

### a.将下载源加入到系统的源列表（添加依赖）

```shell
sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
```

### b.导入谷歌软件的公钥，用于对下载软件进行验证。

```shell
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
```

### c.用于对当前系统的可用更新列表进行更新。（更新依赖）

```shell
sudo apt-get update
```

### d.谷歌 Chrome 浏览器（稳定版）的安装。（安装软件）

```shell
sudo apt-get install google-chrome-stable
```

### f.启动谷歌 Chrome 浏览器。

```shell
/usr/bin/google-chrome-stable
```


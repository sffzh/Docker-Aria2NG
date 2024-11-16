# 说明

## 原项目

原项目为[oldiy/Docker-Aria2NG]([oldiy/Docker-Aria2NG](https://github.com/oldiy/Docker-Aria2NG)

相关文档：

https://odcn.top/2019/01/20/2144/

Docker地址：

https://hub.docker.com/r/oldiy/aria2-ui-ng



## Fork说明

原项目特性见Oldiy老哥的文档。

我根据个人需要进行了一些修改：

1. 原项目同时包含web-ui和aria-ng两个前端项目，并分别暴露端口，我把两个前端项目合并了在同一个端口8080下，aria-ng的根目录是 `/`而web-ui的根目录是`/webui`

2. 原项目增加了一个端口用来通过网页浏览下载目录下的所有文件，我把它去掉了。原因是公网访问不安全，而内网的话还不如直接通过Samba服务访问共享文件夹更快更直观。

3. 更新AriaNg到最新版本。这个只能手动更新文件内容。我试过用脚本获取最新脚本再修文件，但似乎Github网站有什么处理，用脚本获取版本号经常失败。

4. 在Dockerfile中增加了执行用户`aria`。



## 打包镜像说明

<a href="javascript:" id="mark1"></a>

如果我本人还在持续使用这个工具，我会不定期更新Docker镜像，以保持仓库中的镜像使用最新`area2`版本。仓库镜像的版本号会和`area2`版本号同步。

如果我没有更新镜像，而`area2`已经更新了新版本，可以直接拉取此git项目，在本地进行镜像构建，以获得最新版本。

构建命令：

```bash
git pull git@github.com:sffzh/Docker-Aria2NG.git
cd Docker-Aria2NG
sudo docker build -t sffzh/Docker-Aria2NG . 
```

如果在群晖上执行构建，新的映像会直接出现在群晖的【容器管理】套件的映像列表中。

如果群晖上没有安装git套件，可以使用以下命令行获取项目源码进行构建：

```bash
wget -N --no-check-certificate  https://github.com/sffzh/Docker-Aria2NG/archive/refs/heads/master.zip
unzip master.zip
cd  Docker-Aria2NG-master/
sudo docker build -t sffzh/Docker-Aria2NG . 
```

> 映像构建所需时间可能较长，主要是由网络连接速度决定的。可以使用高速VPN，或者使用以下命令使构建在后台运行：
> 
> ```bash
> echo "sudo docker build -t sffzh/Docker-Aria2NG . " > build.sh
> chmod +x build.sh
> nohup sh ./build.sh >> build.log 2>&1 &
> tail -f build.log
> ```



## 容器初始化说明

### 端口映射

需要映射两个端口：

* `8080`：用于前端网页

* `6800`：用于连接到aria2的rpc接口。

群晖部署建议直接把两个端口都通过Web Station设置网页门户，相当于进行反向代理。

### 文件目录映射

需要映射容器中的两个文件夹到宿主机。

* `/conf` 放置aria2配置文件和session文件。

* `/data` 放置下载的文件。

### 手动维护aria2配置文件

aria2的配置文件`aria2.conf`放在 /conf 目录下，映射到宿主机后可以手动修改。初次创建容器时没有此文件，容器启动时会复制一份默认文件。修改后需要重启容器以生效。

### 升级aria2版本

如果想要升级你的aria2版本，则需要删除容器后重新拉取最新映像再重新创建容器。只要保持新容器的文件映射和旧版本相同，即可无须修改其他配置。

升级脚本示例：

```bash
sudo docker pull sffzh/Docker-Aria2NG
docker_name=`sudo docker ps --format "table {{.ID}} {{.Names}} {{.Image}}"|grep aria|awk '{pr
int $2}'`
sudo docker stop $docker_name
sudo docker rm $docker_name
docker run -d --name $docker_name -p 8081:8080 -p 6800:6800 -v /Download:/data  sffzh/Docker-Aria2NG
```

如果Docker仓库中镜像未更新，请参考前文《[打包镜像说明](#mark1)》章节手动构建新镜像。
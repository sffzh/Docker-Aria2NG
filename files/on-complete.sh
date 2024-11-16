#!/bin/sh
if [ $2 -eq 1 ]; then
# 对于Docker只暴露了/data目录到文件系统，所以下载时指定其他目录没有意义。因此强制把所有下载文件移动到/data。
# for Docker container `/data` is the only Dic which mounted to local machine. If any other dictionary was selected while begining downloading, the file will be disapear in file system. So just move downloaded file to `/data` when downloading completed.
	mv "$3" /data
fi
echo [$(date)] $2, $3, $1 "<br>" >> /data/_download.log
---
title: 通过You-Get下载百家讲坛视频实践
date: 2018-03-12 10:24:32
tags: 
 - Python
 - FFmpeg
categories: Python
description: 通过You-Get下载百家讲坛视频实践
---

### 0.准备环境
* [You-Get Doucement](https://github.com/soimort/you-get/ "Frp Releases") 
* FFmpeg Liunx安装
* Python3.4.6 Linux安装

### 1.环境安装


#### 1.1 Python Linux安装

##### 1.1.1 概述
Linux发行版中内置了Python2.X,但是Python官方已经决定废弃Python2.X,[详情在此](https://wiki.python.org/moin/Python2orPython3).我们要使用Python3.X就需要重新安装.就目前发展的趋势来看Python3.X会是主流，但是Python2.X也不会被彻底废弃，毕竟要考虑历史遗留问题。

##### 1.1.1 命令
```Shell
#python3安装
wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz
tar -xvf Python-3.6.4.tgz
mkdir /usr/local/python3
./configure --prefix=/usr/local/python3
make && make install
mv /usr/bin/python /usr/bin/python_bak
ln -s /usr/local/python3/bin/python3 /usr/bin/python
python -V

#将pip3加入PATH
PATH=$PATH:$HOME/bin:/usr/local/python3/bin
source /etc/profile
```

#### 1.2 FFmpeg Liunx安装

##### 1.1.2  FFmpeg概述
FFmpeg是完整的、跨平台的解决方案，可以记录、转换和传输音频和视频。ffmpeg既可以播放视频，也提供命令行工具来处理视频，另外还有强大的视频处理库用于开发。You-Get下载视频的时候如果没有安装FFmpeg,会产生很多问题。

##### 1.1.2  FFmpeg 安装

```shell
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar -xvzf yasm-1.3.0.tar.gz
cd yasm-1.3.0/
./configure
make && make install

wget https://ffmpeg.org/releases/ffmpeg-3.4.2.tar.bz2
tar -xjvf ffmpeg-3.3.1.tar.bz2
cd ffmpeg-3.3.1
./configure --enable-shared --prefix=/username/ffmpeg
make && make install
cd /username/ffmpeg
#会报错
./ffmpeg -version 
#在/etc/ld.so.conf.d/添加ffmpeg.conf,内容就是安装目录下的lib路径
vim /etc/ld.so.conf.d/ffmpeg.conf
/username/ffmpeg/lib
ldconfig 
./ffmpeg -version
```

#### 1.3 You-Get安装

```
pip3 install you-get
```

### 2.下载实践

``` python

# 1.通过HTMLParser解析网页
# 2.将解析到的URL存储到文件
# 3.逐条读取文件中的URL,执行yout-get --format=5 URL
# 4.下载完成后,可以自己下载到本地。
# 链接如下：
#   http://tv.cctv.com/2017/04/09/VIDEKJ6rtm5ysfc8QY3qkaMf170409.shtml
#   http://tv.cctv.com/2017/04/10/VIDEP2nzlgWE6niBmyCYFxsZ170410.shtml
#   http://tv.cctv.com/2017/04/11/VIDEQca2R00FBoMhtnP2wefB170411.shtml
#   http://tv.cctv.com/2017/04/12/VIDErAlxIsxNP39kUvtiN5RQ170412.shtml

import os

with open('file.txt','r') as f:
        for line in f.readlines():
            cmd="you-get --format=5 "+line
            print(cmd)
            os.system(cmd)

```
如下图所示：
![](/uploads/you-get.jpg)



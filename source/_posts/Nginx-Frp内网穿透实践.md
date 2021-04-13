---
title: Nginx+Frp内网穿透实践
date: 2020-03-08 15:48:10
tags: 
 - Golang
 - Frp
 - Nginx
categories: Golang
description: 通过不同的二级域名可以访问内网同一台机器上不同端口提供出来的服务。
---


### 0.准备环境
* [Frp Releases](https://github.com/fatedier/frp/releases "Frp Releases") 
* 内网主机一台(Linux CentOS)
* [外网主机一台(腾讯云(免费七天)，阿里云)](https://cloud.tencent.com/act/free?utm_source=portal&utm_medium=recommend&utm_campaign=free&utm_term=1226 "腾讯云(免费七天)")
* 公网域名一个

### 1.环境安装

#### 1.1 Frp安装及配置

##### 1.1.1 安装

```Shell
wget https://github.com/fatedier/frp/releases/download/v0.16.0/frp_0.16.0_linux_amd64.tar.gz
tar -zxvf frp_0.16.0_linux_amd64.tar.gz
cd frp_0.16.0_linux_amd64
rm -rf frpc*
# 后台启动 nohup ./frps -c ./frps.ini >/dev/null 2>&1 &
```

##### 1.1.2 Frp服务端配置

```
[common]
bind_port = 9898
dashboard_addr = 0.0.0.0
dashboard_port = 7500
dashboard_user = admin
dashboard_pwd = admin
```

##### 1.1.3 Frp客户端配置

```
[common]
server_addr = 1.1.1.1 #公网主机IP
server_port = 9898

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000

[web50000]
type = tcp
local_ip=127.0.0.1
local_port = 50000
use_encryption=false
use_compression=true
remote_port=50000


[web50001]
type = tcp
local_ip=127.0.0.1
local_port = 50001
use_encryption=false
use_compression=true
remote_port=50001
#后台启动 nohup ./frpc -c ./frpc.ini >/dev/null 2>&1 &
```

#### 1.2 Nginx 安装及配置

##### 1.2.1 Nginx安装

```
yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
cd /usr/local
mkdir nginx
cd nginx
wget http://nginx.org/download/nginx-1.13.7.tar.gz
tar -xvf nginx-1.13.7.tar.gz
cd /usr/local/nginx
./configure && make && make install 
vi nginx.conf
```

##### 1.2.2 Nginx配置

```
#添加Server，转发一个，添加一个，frp服务端和客服端保持一致  
server {
	listen       80;
	server_name  test.xxx.com;

	location / {
		proxy_pass http://127.0.0.1:50000;

	}

	error_page 404 /404.html;
		location = /40x.html {
	}

	error_page 500 502 503 504 /50x.html;
		location = /50x.html {
	}
	proxy_connect_timeout 300s;
	proxy_send_timeout 300s;
	proxy_read_timeout 300s;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header REMOTE-HOST $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

```


### 2.域名解析
1. 建立多个二级域名解析，如：aaa.xxx.com,bbb.xxx.com,ccc.xxx.com 
2. 解析到同一个公网主机IP上
3. 在内网机器上，开三台tomcat(注意端口冲突)，修改tomcat/webapps/ROOT/index.jsp(做标识)，在frp client中配置


### 3.测试
可以看到，不同的二级域名可以访问内网同一台机器上不同端口提供的服务。


### 4.参考资料
* [Frp Document](https://github.com/fatedier/frp "Frp Github") 

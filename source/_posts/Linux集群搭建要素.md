---
title: Linux集群搭建要素
date: 2020-02-28 15:07:11
tags: Linux
categories: Linux
description: Linux集群搭建要素。
---

Linux集群搭建要素
### 0.摘要
现在各种集群越来越多，redis,nginx,keepalive,zookeeper,hadoop,storm,spark... 很多新手光是搭环境这一关就彻底跪了，本人也是每次用的时候就弄，不用的时候就放一边，没有仔细整理过步骤。所以决定写一篇文章关于集群搭建过程比较重要的环节，如果环境搭的好，在后期运行程序的时候才能事半功倍。
### 1.  所用软件
#### 1.1. VMware
由于版权问题，不提供下载。(你懂得！)
#### 1.2 CentOS
网易的镜像速度还是非常快的，但是有些老的版本会下载不到。CentOS6和CentOS7差别较大，为了方便起见，还是使用CentOS6.9。
可以去这里[下载](http://mirrors.163.com/centos/6.9/isos/x86_64/)这两个版本
* CentOS-6.9-x86_64-bin-DVD1.iso(完整版本) 
* CentOS-6.9-x86_64-minimal.iso(最小版本)
(建议两个都下，因为使用的时候都是最小版本，但是完整版里面有很多依赖，可以通过挂载本地或者web版yum源配置，下面会介绍。)

### 2. 主机名配置
vi /etc/sysconfig/network
### 3. HOSTS配置
vi /etc/hosts
(把集群中所有节点配置进去，就不要每次都输入ip了)
### 4. 网络配置
#### 4.1 VMware网络配置
在编辑下虚拟网络编辑器，选择NAT模式，编辑网关地址。想了解VMware的网络模式可以参考我的另外一篇[文章](http://wincent.wang/2017/07/04/VMware%E8%99%9A%E6%8B%9F%E6%9C%BA%E4%B8%89%E7%A7%8D%E8%81%94%E7%BD%91%E6%96%B9%E6%B3%95%E5%8F%8A%E5%8E%9F%E7%90%86/)例如：
NAT网关地址 :192.168.100.99
VMnet8      :192.168.100.98
Cluster1 	:192.168.100.100
Cluster2    :192.168.100.101
(以此类推)
配置好这些就可以集群节点之间，宿主机和虚拟机都可以相互通信。
注意:
桥接方式:VMnet0相当于桥，需要连接独立交换机或者路由器。
HOST-ONLYVMnet1相当于交换机或者路由器，只要配置VMnet1所有节点把它当作网关
NAT模式:VMnet8:相当于虚拟出来一个路由器或者交换机，所有节点连接虚拟出来的网关

#### 4.2 Linux网络配置
IPADDR:与网关地址和255广播地址不同即可。
NETMASK:子网掩码
GATEWAY:网关地址
DNS:DNS服务器地址(默认走网关地址)
例如：
vi  /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=00:0C:29:D4:C6:DF
TYPE=Ethernet
UUID=d0bb4883-021d-4dbf-a0a3-4e3d46343a92
ONBOOT=no
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.100.101
NETMASK=255.255.255.0
GATEWAY=192.168.100.99

注:在"/etc/rc.d/rc.loacl"文件的最后一行加入"ifup eth0"语句

### 5. 防火墙
chkconfig iptables off
chkconfig iptables --list

### 6. YUM
#### 6.1 yum常用操作
1. 安装httpd并确认安装
yum instll -y httpd
2. 列出所有可用的package和package组
yum list
3. 清除所有缓冲数据
yum clean all
4. 列出一个包所有依赖的包
yum deplist httpd
5. 删除httpd
yum remove httpd

#### 6.2 yum挂载源
1.   插入CDROM默认会在/dev/cdrom上，挂载到/mnt/cdrom
mount -t iso9660 -o ro /dev/cdrom /mnt/cdrom

2.   修改/etc/yum.repos.d/下的配置文件
[c6-media]
name=CentOS-$releasever - Media
baseurl=file:///mnt/cdrom
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

3.   验证是否挂载成功
yum list

#### 6.2. yum本地源
1. 安装httpd,在/var/www/html/创建cdrom
2. In -s /var/www/html/cdrom  /mnt/cdrom
3. baseurl=file:///mnt/cdrom 修改成http://当前服务器的ip/cdrom

### 7. SSH
ssh安装:sudo yum install ssh
scp安装:sudo yum install -y openssh-clients

ssh-keygen:生成ssh公钥和密钥
ssh-copy-id:copy到目标节点

修改/etc/ssh/ssh_config文件的配置，以后则不会再出现此问题
最后面添加：
StrictHostKeyChecking no
UserKnownHostsFile /dev/null dd

### 8. 添加用户
1. useradd username
2. passwd password
3. vi /etc/sudoers 

### 9. VMware克隆注意点
在克隆过程中，只需要注意两点，网络配置和主机名。
1. 修改：/etc/sysconfig/network-scripts/ifcfg-eth0 删除uuid,hardware
2. 修改网卡规则：/etc/udev/rules.d/70-persistent-net.rules 只留下eth0注意mac地址
3. 修改主机名：/etc/sysconfig/network主机名
4. 重启：reboot

### 11. 软件安装 
#### 11.1 JDK安装
解压配置环境环境变量即可。
#### 11.2 Mysql安装
1. 上传MySQL-server-5.5.48-1.linux2.6.x86_64.rpm、MySQL-client-5.5.48-1.linux2.6.x86_64.rpm到Linux上

2. 使用rpm命令安装MySQL-server-5.5.48-1.linux2.6.x86_64.rpm，缺少perl依赖
rpm -ivh MySQL-server-5.5.48-1.linux2.6.x86_64.rpm 

3. 安装perl依赖，上传6个perl相关的rpm包
rpm -ivh perl-*

4. 再安装MySQL-server，rpm包冲突
rpm -ivh MySQL-server-5.5.48-1.linux2.6.x86_64.rpm

5. 卸载冲突的rpm包
rpm -e mysql-libs-5.1.73-5.el6_6.x86_64 --nodeps

6. 再安装MySQL-client和MySQL-server
rpm -ivh MySQL-client-5.5.48-1.linux2.6.x86_64.rpm
rpm -ivh MySQL-server-5.5.48-1.linux2.6.x86_64.rpm

7. 启动MySQL服务，然后初始化MySQL
service mysql start
/usr/bin/mysql_secure_installation

8. 测试MySQL
mysql -u root -p

#### 11.3 Nginx安装
(待补充)
#### 11.4 Keepalive安装
(待补充)
### 12. Shell脚本
#### 12.1 一键启动集群
(待补充)
### 13. 小技巧
#### 13.1 零等待开机
vi /boot/grub/grub.conf
timeout=0
#### 13.2 切换到命令行模式
vi /etc/inittab(修改系统的默认启动级别)
id:3:default
#### 13.3 将用户加入sudoers
vi /etc/sudoers
#### 13.4 修改自动启动级别
chkconfig iptables off
chkconfig iptables --list
#### 13.5 查看端口
netstat  -nltp

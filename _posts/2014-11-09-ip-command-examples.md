---
layout: post
date: 2014-11-09 00:00:00
modified: 2014-11-09 00:00:00
title: IP Command Examples
---
* toc
{:toc}

无意间发现了这篇文章，从学习 ip 这个命令的角度看，写的还是不错的，所以简单的翻译了放在这里。原文地址 [http://www.tecmint.com/ip-command-examples/](http://www.tecmint.com/ip-command-examples/)。

******

在这片文章里，作者将讲述如何配置静态 IP 地址、静态路由和静态网关等内容。在本文中，将使用命令 IP 给需要的设备配置 IP 地址。命令 IFCONFIG 已经被废弃，并被命令 IP 所取代，但是在很多 Linux 发行版中，命令 IFCONFIG 仍然存在，并且可以用来配置网络。

### 如何配置静态 IP 地址
为了配置静态 IP 地址，你需要修改系统的网络配置文件来给系统分配一个静态 IP 地址。并且要求你是超级管理员，可以通过在终端或命令行输入命令 su 切换用户。

**RHEL/CentOS/Fedora 用户**

使用你最爱的编辑器打开网卡（eth0 或 eth1）的配置文件。例如，为了给网卡 eth0 配置 IP 地址，

~~~
[root@tecmint ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
~~~

可以看到如下类似的内容：

~~~
DEVICE="eth0"
BOOTPROTO=static
ONBOOT=yes
TYPE="Ethernet"
IPADDR=192.168.50.2
NAME="System eth0"
HWADDR=00:0C:29:28:FD:4C
GATEWAY=192.168.50.1
~~~

**对于 Ubuntu/Debian/Linux Mint 用户**

编辑文件 `/etc/network/interfaces` 给网卡 eth0 分配静态 IP 地址。

~~~
auto eth0
iface eth0 inet static
address 192.168.50.2
netmask 255.255.255.0
gateway 192.168.50.1
~~~

在输入完配置信息后，重启网络服务。

~~~
# /etc/init.d/networking restart
~~~

~~~
$ sudo /etc/init.d/networking restart
~~~

## 1. 如何给某一个设备配置地址
如下的命令用来给某一个设备（eth1）配置地址

~~~
# ip addr add 192.168.50.5 dev eth1
~~~

~~~
$ sudo ip addr add 192.168.50.5 dev eth1
~~~

**注意：** 这些配置会在系统重启后丢失。

## 2. 查看 IP 地址
为了查看网络设备的具体信息，比如 IP 地址、MAC 地址等，使用如下命令。

~~~
# ip addr show
~~~

~~~
$ sudo ip addr show
~~~

得到：

~~~
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
inet 127.0.0.1/8 scope host lo
inet6 ::1/128 scope host
 valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN qlen 1000
link/ether 00:0c:29:28:fd:4c brd ff:ff:ff:ff:ff:ff
inet 192.168.50.2/24 brd 192.168.50.255 scope global eth0
inet6 fe80::20c:29ff:fe28:fd4c/64 scope link
 valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN qlen 1000
link/ether 00:0c:29:28:fd:56 brd ff:ff:ff:ff:ff:ff
inet 192.168.50.5/24 scope global eth1
inet6 fe80::20c:29ff:fe28:fd56/64 scope link
 valid_lft forever preferred_lft forever
~~~

## 3. 如何删除 IP 地址
下面的命令可以被用来删除某个设备（eth1）上的 IP 地址。

~~~
# ip addr del 192.168.50.5/24 dev eth1
~~~

~~~
$ sudo ip addr del 192.168.50.5/24 dev eth1
~~~

## 4. 如何启用网卡
在网卡名（eth1）后接‘up’的标示用来启用这个网卡。比如，下面的命令将激活（启用）eth1 网卡。

~~~
# ip link set eth1 up
~~~

~~~
$ sudo ip link set eth1 up
~~~

## 5. 如何关闭网卡
在网卡名（eth1）后接‘down’的标示用来关闭这个网卡。比如，下面的命令将激活（启用）eth1 网卡。

~~~
# ip link set eth1 down
~~~

~~~
$ sudo ip link set eth1 down
~~~

## 6. 如何查看路由表
使用如下的命令查看系统的路由表

~~~
# ip route show
~~~

~~~
$ sudo ip route show
~~~

得到：

~~~
10.10.20.0/24 via 192.168.50.100 dev eth0
192.168.160.0/24 dev eth1proto kernelscope linksrc 192.168.160.130metric 1
192.168.50.0/24 dev eth0proto kernelscope linksrc 192.168.50.2
169.254.0.0/16 dev eth0scope linkmetric 1002
default via 192.168.50.1 dev eth0proto static
~~~

## 7. 如何添加静态路由
之所以要添加静态路由，是因为并不是所有的数据都要通过默认网关发送。我们可以添加静态路由使传输的数据包经过最佳路经到达目标。

~~~
# ip route add 10.10.20.0/24 via 192.168.50.100 dev eth0
~~~

~~~
$ sudo ip route add 10.10.20.0/24 via 192.168.50.100 dev eth0
~~~

## 8. 如何删除静态路由
敲入如下命令即可删除对应的路由

~~~
# ip route del 10.10.20.0/24
~~~

~~~
$ sudo ip route del 10.10.20.0/24
~~~

## 9. 如何永久添加路由
在系统重启后，上面添加的路由都会丢失。永久的添加一条静态路由，

**对于 RHEL/CentOS/Fedora 用户**

需要编辑文件 `/etc/sysconfig/network-scripts/route-eth0`，输入路由配置

~~~
# vi /etc/sysconfig/network-scripts/route-eth0
~~~

~~~
10.10.20.0/24 via 192.168.50.100 dev eth0
~~~

**对于 `Ubuntu/Debian/Linux Mint` 用户**

需要编辑 `/etc/network/interfaces`，添加静态路由信息。

~~~
$ sudo vi /etc/network/interfaces
~~~

~~~
auto eth0
iface eth0 inet static
address 192.168.50.2
netmask 255.255.255.0
gateway 192.168.50.100
#########{Static Route}###########
up ip route add 10.10.20.0/24 via 192.168.50.100 dev eth0
~~~

## 10. 如何添加默认网关
既可以全局配置网关也可以按照网卡配置网关。当我们的机器有多个网卡的时候，配置默认网关的优点就显现出来了。具体的操作可以参考下面的命令。

~~~
# ip route add default via 192.168.50.100
~~~

~~~
$ sudo ip route add default via 192.168.50.100
~~~

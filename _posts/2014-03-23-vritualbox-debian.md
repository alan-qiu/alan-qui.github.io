---
layout: post
title: Debian in Virtualbox and APT
date: 2014-03-23 00:00:00
modified: 2014-03-23 00:00:00
---
* toc
{:toc}

Debian 7 wheezy 默认已经包含了 virtualbox 的客户系统增强功能包（guest additions），但是 stable 的特点决定了这个内含的版本是足够陈旧的。所以在 virtualbox 里安装了 Debian 7 以后，最好再安装最新的增强包。

通过如下命令可以看到 Debian 7 默认包含的 virtualbox-guest-utils 版本

~~~sh
# lsmod | grep -io vboxguest | xargs sudo modinfo | grep -iw version
# version: 4.1.18_Debian
~~~

## 安装最新的增强包
第一步，准备编译工具

~~~sh
# apt-get install build-essential module-assistant
~~~

第二步，安装需要的内核文件

~~~sh
# sudo m-a prepare
~~~

第三步，安装增强包。首先点击 virtualbox 虚拟机管理窗口里的“设备”－“安装增强功能”加载增强包所在的 ISO 文件。然后启动安装程序。

~~~sh
# sudo mount-t iso9660 /dev/cdrom /media/cdrom
# cd /media/cdrom
# ./VBoxLinuxAdditions.run
Verifying archive integrity... All good.
……
Setting up the Window System to use the Guest Additions ...done.
You may need to restart the hal service and the Window System (or just restart
the guest system) to enable the Guest Additions.
……
~~~

自此，安装操作完成，下面重新启动（也可以不重启）Debian，可以看到

~~~sh
# lsmod | grep -io vboxguest | xargs sudo modinfo | grep -iw version
# version: 4.3.8
~~~

## 使用缓存的 ISP
如果你的 ISP（比如赫赫有名的长城宽带） 使用了缓存技术的话，你在更新 Debian (`sudo apt-get update`) 的时候，可能会遇到类似这样的错误提示“Hash 校验和不符，无法重建软件包缓存”。引发这个错误的主要因素是 apt 下载的软件包是 ISP 缓存的，不是源服务器的。这时除了换网络，比如使用 VPN 之类的，没有办法了。

最近一段时间的实践表明，Debian stable 版本一般不会出现这个问题，大约这就是软件包老的好处吧。淡然也有可能是 ISP 没有缓存我现在使用的 aliyun 源。

最后推荐下 aliyun 的镜像服务，速度不错。[http://mirrors.aliyun.com](http://mirrors.aliyun.com)

p.s.
据说今天是某人的生日，所以找了个借口写了这篇东东。Happy Birthday。

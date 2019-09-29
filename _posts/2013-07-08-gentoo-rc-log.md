---
layout: post
date: 2013-07-08 00:00:00 +1000
modified: 2019-09-30 00:00:00 +1000
title: gentoo 中 rc 的启动日志设置
---

有的时候在启动系统的过程中，我们会在屏幕上看到一些 fail 或者 error 的消息，但是等到出现登录命令行的时候，这些消息已经不在屏幕上了。怎么查看他们呢？

有些信息可以通过 `dmesg` 或者 `message` 查看到，有些看不到，比如关于 `cpufrequtils` 的，关于 virtualbox 的。这些信息在哪里？

通过观察我们可以发现，`cpufrequtils` 和 vitualbox 都是通过 `/etc/init.d/` 里面的启动脚本启动。所以我们的问题就变成了寻找 `rc` 的日志或者是配置系统使得 `rc` 的日志被记录下来。

查看 `/var/log` 是否包含 `rc.log` 这个文件（我们假设使用默认的日志文件名），如果没有那个文件，那么我们需要查看 `rc` 的配置文件 `/etc/rc.conf`。查找 `rc_logger` 关键字，我们可以发现如下内容:

```sh
# rc_logger launches a logging daemon to log the entire rc process to
# /var/log/rc.log
# NOTE: Linux systems require the devfs service to be started before
# logging can take place and as such cannot log the sysinit runlevel.
#rc_logger="YES"
# Through rc_log_path you can specify a custom log file.
# The default value is: /var/log/rc.log
#rc_log_path="/var/log/rc.log"
```

现在我们需要做的就是把如下两句的注释取消。

```sh
rc_logger="YES"
rc_log_path="/var/log/rc.log"
```

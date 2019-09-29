---
layout: post
date: 2014-02-28 00:00:00
modified: 2019-09-28 00:00:00
title: OSX 的几个命令行程序
excerpt: a few notable osx specific commands.
tags: [osx, command]
published: true
---

OSX 已经包含（已经默认安装或者可以使用 homebrew 安装）了大部分大家知道并喜爱的 Linux 命令行程序（不过这些程序在 OSX 和 Linux 下略有不同，因为 Linux 是 GNU 派系的，而 OSX 是 BSD 派系的）。然而 OSX 同时提供了一些自有的值得注意的命令行程序：

- `open` - 用桌面程序打开一个文件或者目录，例如 `$ open doc.pdf`
- `pbcopy` 和 `pbpaste` 允许操作者在命令行里使用粘贴板
- `launchctl` 大约相当于某些 Linux 发行版里的 `service` 和 `chkconfig` 命令
- `fs_usage` 监控计算机文件系统的使用情况
- `system_profiler` 提供计算机硬件配置的信息（和命令 `lshw` 类似）

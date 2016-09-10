---
layout: post
date: 2016-03-25
modified: 2016-03-25
title: 使用 Rclone 同步 Google Drive
tags: [rclone, google dirve]
---

Google 始终没有发布 drive 的 linux 客户端。对于 linux 用户来说，不使用 google drive 是最好的选择。但是如果你还是想使用 google drive 该怎么办呢？作者最近发现 [Rclone](http://rclone.org/) 可以满足这个要求。

#### 安装与配置

如果你使用的是 ArchLinux 的话，可以使用 pacman 安装。其他 Linux 用户请参考[官方文档](http://rclone.org/install/)。

安装好之后需要先配置才能使用，运行

```sh
$ rclone config
```

出现的是交互式的配置界面。这里以 google drive 为例，默认的配置即可工作，请参考[文档](http://rclone.org/drive/)。

#### 简单使用

##### 下载（上传）

语法规则是 **rclone copy source:path dest:path**。

```sh
$ rclone copy gdrive:backup /home/username/gdrive/backup
```

下载 google drive 的文件夹 backup 到本地的 `gdrive/backup` 目录。`gdrive:` 是之前配置 rclone 是命名的 google drive。

```sh
$ rclone copy /home/username/gdrive/backup-cloud gdirve:backup-cloud
```

把本地的 `gdrive/backup-cloud` 目录上传到 google drive 中。

##### 同步

```sh
$ rclone sync /home/username/gdrive/sync gdirve:sync
```

同步本地的 `gdrive/sync` 目录和 google drive 的 sync 文件夹。

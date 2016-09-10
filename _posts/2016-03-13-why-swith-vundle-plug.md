---
layout: post
date: 2016-03-13
modified: 2016-03-13
title: 从 Vundle 迁移到 Plug 的原因（译）
tags: [vim,vundle,plug]
---

* toc
{:toc}

##### Vundle 不再被活跃的维护

Vundle 的创造者 Gmarik [宣布](https://github.com/gmarik/Vundle.vim/issues/608)不再维护 Vundle。也许有人会接过这个项目，但当前的情形是已经很久没有人接管这个项目了。

##### 方便的自启安装

（略）

##### 插件的“延迟加载”

启用很多插件会显著的增加 Vim 的启动时间。Plug 通过允许推后一些插件的加载来加速 vim 的启动。

比如，作者只在编辑 markdown 文件的时候才需要 markdown 语法插件：

    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

只在运行 `Rename` 命令是才需要 rename 插件：

    Plug 'AlexJF/rename.vim', { 'on': 'Rename' }

##### 更快的安装插件

如果你的 Vim 编译选项里包含 Ruby，就像作者的 vim 版本一样，Plug 可以并行的更新／安装插件。如果你的没有包含 Ruby，那么 Plug 会回退到原生的 Vim 方式。

---
翻译，为了阅读和练习。原文在[这里](https://jordaneldredge.com/blog/why-i-switched-from-vundle-to-plug/)

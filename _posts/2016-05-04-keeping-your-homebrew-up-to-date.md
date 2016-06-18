---
layout: post
date: 2016-05-04
modified: 2016-05-04
title: 保持 Homebrew 最新
tags: ['homebrew', 'tips']
---

* toc
{:toc}

在这篇文档中，作者将要介绍如何保持 Homebrew 最新，并且确保使用最优的方法。

## Tip #1 更新你的 Homebrew

你总是希望可以运行最新版本的 Homebrew，使用主仓库中最新的 formulae。这一切都可以使用 `brew update` 来完成：

~~~sh
$ brew update
Already up-to-date
~~~

## Tip #2 了解已经安装了哪些软件包

使用包管理工具的一个潜在问题是 app-creep，下载了最新、最棒的软件到你的 Mac 里，但是从来不使用它们。偶尔你需要运行 `brew list`，它会告诉你你的机器上使用 Homebrew 安装的东西：

~~~sh
$ brew list
lynx openssl wget
~~~

类似的，你可以运行 `brew info [package]` 来得知每个包的信息：

~~~sh
$ brew info wget
~~~

## Tip #3 卸载不使用的软件

当你发现软件已经过时了，你可以轻易的卸载它们。所要做的只是运行 `brew uninstall [package]`，然后那个软件就消失了：

~~~sh
$ brew uninstall wget
Uninstalling /usr/local/Cellar/wget/1.15...
~~~

不幸的是，卸载软件包并不会自动卸载它依赖安装的软件包，所以你需要手动卸载它们，一次一个软件包。

你需要自己确保卸载的软件包不被别的软件所依赖，Homebrew 不会阻止你那么做（卸载被别的软件包依赖的软件包）。

## Tip #4 检查在使用的软件

使用软件管理工具的一个很爽的事情是你可以不断的保持已经安装的软件是最新版本。不需要你记得软件是从哪儿下载的，也不用费心寻找更新包。相反的，只要运行几条命令就可以自动更新所有的软件包。

从查看哪些软件包已经有更新了是最安全的。你需要先运行 `brew update` 确保你的软件包列表是最新的，然后运行 `brew outdated`；

~~~sh
$ brew outdated
~~~

这条命令是纯粹输出信息的，它告诉你哪些软件包需要被更新。

## Tip #5 更新过时的软件

一旦你了解了有哪些需要被更新，你可以仅仅通过一个命令来更新所有的 Homebrew 所安装的软件包：

~~~sh
$ brew upgrade
~~~

可能因为某个软件包对你很重要，或者是你需要运行旧版本的软件包，你不想更新某个软件包。在这种情况下，你应该通过“pinning”那个软件包来阻止它升级。下面的演示命令会保持 MySQL 的版本不升级：

~~~sh
$ brew pin mysql
~~~

现在你运行 `brew upgrade` 后只会升级被 pinned 之外的软件包。在将来，你可以通过 `brew unpin [package]` 的方法来恢复这个软件包的版本升级。

如果你希望只更新某个软件包，你可以有选择的使用 `brew upgrade` 命令。下面的演示只升级 wget 软件包：

~~~sh
$ brew upgrade wget
~~~

---

为了阅读和练习翻译，原文在[Keeping Your Homebrew Up to Date](https://www.safaribooksonline.com/blog/2014/03/18/keeping-homebrew-date/)。

补充：可以使用 [homebrew-rmtree](https://github.com/beeftornado/homebrew-rmtree) 这个工具卸载 homebrew 安装的软件包，homebrew-rmtree 会自动探测依赖关系。

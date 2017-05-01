---
layout: post
date: 2017-04-12 21:09:00
modified: 2017-04-12 21:09:00
title: 更好的 Git（译）
tags: [git]
---

这是一片读书摘抄笔记，原文是 [Beter Git configuration]()。文章的作者给出了不少好的建议，以及这些建议适用的场景。👍

---

## 全局配置

在用户主目录下的 `.gitconfig` 文件中存放着 Git 的全局配置。

### 别名

`.gitconfig` 的 [alias] 部分用来定义你自己的命令。感觉缺少了什么，加进去！

* `prune = fetch --prune` Prune 会删除任何已经在远程仓库里被删除了的本地分支。
* `undo = reset --soft HEAD^` 恢复到你提交 commit 之前的状态。如果仅仅是为了修改 commit 信息，那么可以使用 amend。
* `stash-all = stash save --include-untracked` 在你不得不临时 check out 到别的分支时，Stash 时非常有用的工具。
* `glog = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s%Cgreen(%cr) %C(bold blue)<%an>%Creset'` 紧凑的、多种颜色的、图形化的显示 Git 日志中最重要的信息。

### 合并

`ff = only` 一定会带来错误，除非你的每个合并都是“fast-forward”。没有合并的提交，没有两个提交历史的交叉，有的只是从一个提交到另一个提交的演变。

你可能想知道如何才能做到这样的合并。秘诀是 `git rebase`，把一个分支中的所有提交附加在另外的分支后面，构建一个新的分支“基础”的方法。

`conflictstyle = diff3` 不是很清楚 diff3 的好处在那里，用用先。

### 提交

使用 GPG 签名提交？

`gpgSign = true` 会确保你的每个提交都被你的 GPG 密钥所签名。这么做是个好的想法，因为 `.gitconfig` 文件中没有对用户信息的验证，没有验证意味着在别人的 PR 里可以包含你的提交？？？（不懂）

你还可以把你的 GPG 公开密钥放到你的 GitHub 账户中，这样你签名过的提交会显示一个“Verified”的图章。

- 如果你有多个 GPG 密钥，可以使用 `user.signingKey` 选项指定使用哪一个。
- GUI 的工具可以能不一定会签名你的提交，即使你已经在 `.gitconfig` 中设置了，要看看那个工具的选项。
- `gpg-agent` 是一个好用的工具，可以一次性保存你所有的 passphrase。推荐！
- 在 Mac 中如果使用 GnuPG2，需要在 shell 里设置 set GPG_TTY (tty) (fish shell)。

### 推送

你可能已经设置了 `default = simple`。这个选项让你把本地分支推送到同名的远端仓库里。

`followTags = true` 会让你把本地的 tags 都推送到远端，伴随着 `git push`，而不需要手动添加选项 `—follow-tags`。

### 状态

默认情况下，如果你新建了一个目录，并在这个目录下新建了一些文件，当你使用 `git status` 时，你只能看到一个目录的名字，而看不到目录下的文件。有时候这样的显示会误导你。`showUntrackedFiles = true` 的选项会显示所有的新文件，而不仅仅是一个目录名，在你使用 `git status` 时。

需要注意的是，如果这么做会让 git 运行缓慢，如果你工作在一个大的仓库中。

### Transfer

没看懂。

### Diff Tool: icdiff

在使用内建的 `git diff` 之外，Git 允许你使用外部的工具来展示你的 diffs。下面的这些设置可以让 Git 使用 icdiff 来展示你的仓库中两个不同状态的差异：

``` git
[diff]
  tool = icdiff
[difftool]
  prompt = false
[difftool "icdiff"]
  cmd = /usr/local/bin/icdiff --line-numbers $LOCAL $REMOTE
```

现在你可以这样查看 diff `git difftool master branch`。

**注意：**icdiff 并不能处理所有的情景，把 `git diff` 留作后备是个好主意。


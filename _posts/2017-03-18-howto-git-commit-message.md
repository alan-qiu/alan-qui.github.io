---
layout: post
date: 2017-03-18 00:00:00
modified: 2017-03-18 00:00:00
title: 如何编写 Git Commit Message
excerpt: how to write a git commit message.
tags: [git, commit, howto]
---

这是一片读书摘抄笔记，关于如何写好 Git Commit Message。

---

原文是 [how to write a git commit message](https://chris.beams.io/posts/git-commit/?utm_source=wanqu.co&utm_campaign=Wanqu+Daily&utm_medium=website)。

你做了哪些更改会有代码的差异告诉人们，你为什么这么做，只有提交信息才能讲述。

如果你还没有思考过什么是好的 Git 提交信息，那么你应该还没有在 git log 和相关的工具上花费过比较多的时间。

The seven rules

1. Separate subject from body with a blank line
2. limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line  
_Imperative mood_ just means "spoken or written as if giving a command or instruction".  
Use of imperative is important only in the subject line.
6. Wrap the body in 72 characters
7. Use the body to explain _what_ and _why_ vs. _how_

---

之前还看过 ruanyifeng 写的一片文章，[Commit message 和 Change log 编写指南](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)。里面也有一些好的规则（Angular 规则）可以参考。

1. Commit message 分为三个部分：header、body 和 footer。
2. Header 部分只有一行，包含三个字段：type、scope 和 subject。
  + type 使用如下七个标识。
    - feat：新功能（feature）
    - fix：修补bug
    - docs：文档（documentation）
    - style： 格式（不影响代码运行的变动）
    - refactor：重构（即不是新增功能，也不是修改bug的代码变动）
    - test：增加测试
    - chore：构建过程或辅助工具的变动
  + scope  
  用于说明 commit 的影响范围，比如数据层、控制层、视图层等。
  + subject  
  是 commit 的简短描述，不超过 50 个字符。
3. Body 是对本次 commit 的详细描述，可以分成多行／多段。
  + 使用第一人称现在时，比如使用 chang 而不是 changed 或 changes。
  + 应该说明代码变动的冬季，以及与以前行为的对比。
4. Footer 只用于两种情况。
  + 不兼容的变动  
  以 BREAKING CHANGE 开头，后面是对变动的描述、以及变动的理由和迁移方法。
  + 关闭 issue  
  比如 `Close #234` 或 `See 123`。

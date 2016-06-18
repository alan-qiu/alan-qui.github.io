---
layout: post
date: 2016-03-21 
modified: 2016-03-21
title: 评估 Rails 项目的十个步骤（译）
---

* toc
{:toc}

在某个时候，你需要决定是否要维护某个 Rails 项目。如果你认真的考虑这件事情的话，你应该完成下面的十个步骤：

## 建立开发环境

把代码克隆下来，尝试启动服务器。说明文档是否足够清晰？你是否能够按照文档中说明的步骤把项目跑起来？

很多项目的 README 都是陈旧的，并且（或者）里面的说明并不能正常工作。

大多数的项目都会如下定义指南：

- 配置你的 `config/database.yml`
- 配置你的 `.env` 文件
- 建立数据库 `rake db:create db:migrate db:seed`
- 启动服务器 `rails server`

好的项目会有一个单行的文件来建立开发环境，比如

```shell
cd /path/to/project
./bin/setup
rails server
```

## 运行测试

一旦你建立了开发环境，尝试去运行测试。比如：

```
rake
```

任何正式的 Rails 项目都会通过测试，即使测试的并不充分。

一般构建测试的时间不会超过 10 分钟。有些测试需要更多的时间，特别是当包含集成测试（例如使用 `Selenium` 驱动的集成测试）的时候。

测试通过了么？有失败的案例？有多少测试失败了？

在最好的情景，所有的测试都会通过。

## 审查 schema.ra

最好的查看程序复杂程度的方法是数一数数据库中有多少表。有超过 20 张表么？超过 100 张？你可以容易的绘出主要 model 的 [ERD](https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model) 吗？这些表是符合标准的么？

作者喜欢画出核心的事务表和它们之间的关系。这样可以帮助作者理解项目背后的商业逻辑。

## 审查 .env

项目中有`.env`或类似的文件么？如果项目中没有类似的文件，则喻示着在跨环境（开发、测试、staging，生产）时会遇到很多困难。

目前为止，我们应该都知道[我们应当使用环境变量](http://12factor.net/config)。如果开发这个项目的人没有使用 *env* 变量，你可能会在代码库中发现一些条件语句来区分不同的运行环境。

## 检查 Gemfile

找到项目使用的 Rails 版本。是最新的么？比 3.0 还要旧？

我们都知道，升级 Rails 项目可不是一件轻而易举的事情。

是否使用了已经不再被维护的 gem？如果有的话，意味着你需要迁移到新的 gem，这会给你的评估工作增加额外的工作量和影响。

## 运行 bundle-audit

[Bundler Audit](https://rubygems.org/gems/bundler-audit)是一个很有用的工具，用来检查 `Gemfile.lock` 中的 gem 的已知漏洞。

如果有任何的漏洞发现，这个工具会给出已经打了补丁的 gem 版本号。

在最好的情景下，你会看到下面类似的语句：

```
$ bundle-audit
No vulneralbilities found
```

## 配置代码分析（code climate）

这是一个快速（付费）检查代码质量的方法。在 [Ombu Labs](http://www.ombulabs.com/)，我们使用一个商业账号来分析我们的产品和客户的项目。

[Code Climate](https://codeclimate.com/) 是一个付费服务，自动检测代码的测试覆盖、复杂度、重复性、安全和风格。

你可以快速的发现代码热点、潜在的问题、潜在的 bug 风险和代码覆盖情况。

项目的 [GPA](https://docs.codeclimate.com/docs/gpa) 是多少？4.0？1.5？这项会给你复杂度的全局感觉。4.0 是最高的得分。

自由替代工具可以检测部分（或全部）Code Climate 的项目：

- [flog](https://rubygems.org/gems/flog)
- [flay](https://rubygems.org/gems/flay)
- [metric_fu](https://rubygems.org/gems/metric_fu)
- [simplecov](https://rubygems.org/gems/simplecov)

## 检查代码覆盖率

尽管作者很喜欢 Code Climate，[simplecov](https://rubygems.org/gems/simplecov) 却可以更快的构建出一份代码覆盖情况的报告。

这个工具可以在应用层告诉你代码的测试覆盖率。多少百分比的 model 是测试过了？多少百分比的 controller 是测试过的？

哪个文件是被最少测试的？每个文件有多少有效的行？有多少被测试覆盖了？

全局的测试覆盖百分比可以告诉你之前的开发者在多大程度上关心测试。

如果你计划更改代码，那么你需要确保这些代码是被测试过的。不然这将是成为一个噩梦。

你应该对测试代码作审查，确认覆盖情况。

## 研究开发流程

开发者们是否有引入变更的流程？他们在合并代码到主分支之前是否作代码审查？他们是否使用 [CI](https://en.wikipedia.org/wiki/Continuous_integration) 服务来运行每个 pull request？他们使用 pull request 么？

之后 3 个月的路线图是怎么样的？项目面临紧急情况么？需要“救火员”么？为什么项目遇到紧急清况？

## 审查性能状态

他们使用 [Skylight](https://www.skylight.io/r/qGCIS90vk2nD)？[NewRelic](http://newrelic.com/)？最慢和最繁忙的请求是什么？最大的性能问题是什么？

大多数项目是没有从这些（付费）服务中得到信息的。所以你需要找到你的方案。如果他们使用 [Google Analytics](https://www.google.com/analytics/)，也许你可以发现一些性能差的页面的信息。

# 总结

这些步骤是我们目前用来在接管 Rails 项目前作评估用的。这些步骤对我们非常有帮助。作者建议你也使用这些步骤尽可能客观的评估项目的质量。

项目管理者、项目所有者和创始人不了解代码的状态。你不能相信他们的观点。

在 Ombu Labs，如果这些步骤都通过了，我们会开心的接管项目。如果大部分步骤失败了，我们一般会给对方的公司发一份免费的代码质量报告并婉据接管要求。

---

为了阅读和翻译，原文[10 Steps to Evaluate a Rails Project](http://www.ombulabs.com/blog/rails/maintenance/ten-steps-to-evaluate-a-rails-project.html)

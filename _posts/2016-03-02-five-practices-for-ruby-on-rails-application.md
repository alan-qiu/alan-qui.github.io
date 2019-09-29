---
layout: post
date: 2016-03-02
modified: 2019-09-30
title: 增加 Rails 应用健壮性的五个实践
tags: [rails]
---

<!-- prettier-ignore -->
* toc
{:toc}

原文 http://brewhouse.io/2016/02/26/five-practices-for-robust-ruby-on-rails-applications.html

## 使用 `Hash#fetch` 拦截畸形的 hash

`unexpected method 'upcase' for nil`... 任何时候，只要你期望一个 Hash 包含至少一个键值，那就使用 `fetch()` 而不是 `[]`。如果 Hash 中没有键值，`fetch()` 会抛出一个错误，阻止把 `nil` 传递出去，阻止 `nil` 引发的一条和上下文不想关的错误。

## `case ... else raise` 拦截无效的数据

总是在 `case` 语句结束的时候添加 `case rails ...`。当个收到一个异常的值是，你会想知道是什么时候出现的，而不是忽略它继续。

## 使用 ActiveRecord 的 `!` 方法显示的报错

在公司里，数据总是被看作是最有价值的资产。错误静默模式下写入数据会造成巨大的影响（坏的）。只要你不想一个操作失败，那就使用爆炸性方法，`create!` `update!` 和 `destroy!`，来抛出异常当操作失败时。这个做法会保证你远离不一致数据的处理。

在测试代码中，这个做法可以保证配置（setup）不会静默的失败…… 没有什么比配置不正确导致测试失败更糟糕的了。

同样的，总是把多个调用放在一个 SQL 事物里，防止数据处于 in-between 状态。

## 使用 ActiveRecord 的验证进行 live check

联合使用 ActiveRecord 验证和爆炸性方法是一个绝佳的阻止写入无效数据的方法。例如

    class Post < ActiveRecord::Model
      validates :author, :blog, presence: true
      validates :published_by, presence: true, if: :published?
      validates :comment_count, numericality: { greater_or_equal_to: 0 }
    end

## 使用数据库一致性来保证数据的一致

在保证数据是可用，没有重复和孤立的时候，数据库是最好的工具。

### `null: false`

鉴于数据库中的大部分列都会被请求到，在定义列的时候默认 `null: false`。

### `index ... unique: true`

你是否了解到 rails 的 `has_one` 方法并不阻止重复的相关项被创建？

    class Account
      has_one :account_settings
    end

    account # Account.create!
    account.create_account_settings!
    account.create_account_settings!
    account.create_account_settings!

    account.account_settings
    # => one of the three account settings you've create...

阻止这种数据不一致的方法是添加唯一性索引

add_index :account_settings, :account_id, unique: true

之后，当你不小心重复创建了相关项时，数据库会抛出错误。

### `foreign_key`

你不希望有几行数据在数据库里是鼓励的吧？

外键就是用来预防上述事情发生的工具。作者推荐使用 gem [shcema_auto_foreign_keys](https://github.com/SchemaPlus/schema_auto_foreign_keys) 来自动添加外键。

## 越少的 keystrokes 越好

越少使用额外的 keystrokes，越少的时间花在 debugging 和修复不一致的数据上。使用 `!`, `raise`, `validate` 和数据库的一致性，你的合作者和未来的你都会因此感谢你。

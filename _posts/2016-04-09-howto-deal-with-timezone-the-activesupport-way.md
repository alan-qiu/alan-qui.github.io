---
layout: post
date: 2016-04-09
modified: 2016-04-09
title: 使用 Active Support 的方式处理时区问题
tags: [active support, timezone]
---

当我们讨论时区偏移或考虑夏令时间时，经常会听到“好吧，这段代码有些糟糕，因为我们不得不……”。

除非开发者所在的公司的大部分用户都在一个时区里（UTC 时区），不然就要编写涉及不同时区的软件，而这是一个令人畏惧的任务。幸好，Ruby on Rails 的 `ActiveSupport` 库提供一些非常好的、无价的特性，帮助我们处理时间相关的问题。

##### 内建的时区

Rails 4.0+ 的 `ActiveSupport` 在 `TimeZone` 类中列出了所支持的所有时区：

```ruby
ActiveSupport::TimeZone.all.map(&:name)
#=> ["American Samoa", ...]
```

`Time` 对象解析传入的时区字符串时基这个时区列表，从一个当前的对象的时区转变为作为参数传入的时区。如果处理的美国时区问题，有一个额外好用的方法 `us_zones`。

一个有趣的细节是这个时区列表里缺少了夏令时的内容。不考虑夏令时让这个方法的使用更简单。A developer does not need to worry about using one timezone object over another due to the time of the year.（没看明白在说啥子）

##### `Time.use_zone`

`ActiveSupport` 库为 Ruby 的类添加了一些实用的的功能。其中的一个是可以设置和取回 `Time` 类的 `zone` 属性。一旦 `zone` 属性被设定，在 `Time` 解析传入的时间字符串时会为时间添加时区：

```ruby
Time.zone = 'Pacific Time (US & Canada)'
Time.zone.parse('2016-04-01 10:00:00')
#=> Fri, 01 Apr 2016 10:00:00 PDT -07:00
```

这段代码接收一个无时区标示的时间戳字符串，解析字符串时使用 `Time.zone` 的值为解析出的时间赋予太平洋时区。

然而这段代码也有个潜在的危险问题。`zone` 属性在余下的 Ruby 运行时中一直存在，可能会在之后引发意料之外的问题。

幸运的是，`ActiveSupport` 给出了 `use_zone` 方法解决这个问题。这个方法接收相同的时区字符串并且接收一个代码块。

`Time.zone` 只影响传入的代码块，排除了 `zone` 影响以后代码的可能性。

```ruby
Time.zone.name
#=> "UTC"

Time.use_zone('Pacific Time (US & Canada)') do
  Time.zone.name
  # => "Pacific Time (US & Canada)"
  Time.zone.parse('2016-04-01 10:00:00')
  #=> Fri, 01 Apr 2016 10:00:00 PDT -07:00
end

Time.zone.name
#=> "UTC"
```

当处理一组用户，并且每个用户有自己对应的时区时，临时设定 `zone` 属性的方法很有帮助。

##### `TimeWithZone.in_time_zone`

使用 `Time` `Date` 和 `DateTime` 对象时，处理时区的转化是单调无趣的。`in_time_zone` 方法降低了这些对象的时区转化复杂度。

单独使用时，`in_time_zone` 会把一个已有的对象转化为 `TimeWithZone` 的实例：

```ruby
now = Time.now
# => 2016-04-04 03:55:24 +0000
now.in_time_zone('Hawaii')
# => Sun, 03 Apr 2016 17:55:24 HST -10:00
```

在一些思路清晰的系统里，总是把 UTC 时间戳存放在数据库中。当把时间戳告诉用户时，使用 `in_time_zone` 方法可以迅速的把时间戳转为用户的本地时间。

再举一个更有创造性地使用 `in_time_zone` 的例子，我们假设有一个处理时刻列表的应用。这个应用在相同的用户本地时刻给用户发送一封电子邮件。比如说，不管它的用户生活在哪里，他们总是会在本地时间上午 10:30 收到一份电子邮件。

一个可能，但不是我们想要的初级实现：

```ruby
user.time_zone
# => Hawaii
send_time = Time.new(2016, 04, 01, 10, 30)
# => 2016-04-01 10:30:00 +0000
send_time.in_time_zone(user.time_zone)
# => Fri, 01 Apr 2016 00:30:00 HST -10:00
```

喔，这段代码是错误的。这段代码初始化了一个 `Time` 对象用来定义“正确”的发送时间，但是 `in_time_zone` 方法不但把对象的时区变成了用户的本地时区，而且修改了时间值。这样以来，所有的用户都会在同一个时间收到邮件，但是相对于他们生活的地方（本地时区）来说，不是一个合适的时间。

解决这个问题的一个可能的方法是修改时间戳字符串的时区部分（末尾的“＋000”），然后重新解析。不过这个方法容易引发错误，并且难以理解。

考虑到 `Date` 类可以调用 `in_time_zone` 方法，最简单的方法可能是初始化一个用户时区的 `DateTime` 对象，然后加上 10.5 个小时：

```ruby
user.time_zone
# => Hawaii
beginning_of_day = Date.today.in_time_zone(user.time_zone)
# => Sun, 03 Apr 2016 00:00:00 HST -10:00
beginning_of_day += (10.5).hours
# => Sun, 03 Apr 2016 10:30:00 HST -10:00
sender = ImportantEmailSender.new(user)
sender.send_at!(beginning_of_day)
```

太棒啦！电子邮件会在 Hawaii 时区的上午 10:30 发送，而且我们避免了字符串的修改和时间对象的转化。生活在 London 的用户同样会在本地时区的上午 10:30 收到邮件，同时这段代码不会增加应用的复杂度。

---

为了阅读和翻译练习，原文在[How to Deal with Timezones the Active Support Way](http://jakeyesbeck.com/2016/04/03/how-to-deal-with-timezones-the-active-support-way/?utm_source=rubyweekly&utm_medium=email)。

译者在以前的项目中也遇到了一些时区的问题，但是 Boss 和开发者的处理方式是把时区的偏移写在代码里，译者很是不赞同。但苦于不了解 Rails，没能说服同事采用 Rails 内建的 timezone 处理方法。如果还会遇到类似的情景，译者准备推荐这篇文章给同事看。

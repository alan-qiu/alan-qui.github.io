---
layout: post
date: 2016-03-14
modified: 2016-03-14
title: 一个迭代方法（译）
tags: [ruby,enumerable,each_cons]
---

* toc
{:toc}

Enumerable 是一个令人惊奇的模块，也是使得 Ruby 成为伟大的编程语言的重要原因。

Enumerable 提供了各种酷方法，比如 `map`，`select`和`inject`。但是作者新的最爱是`each_cons`。

这个方法很有用，你可以用来 [find n-grams](http://www.blackbytes.info/2015/09/ngram-analysis-ruby/)，或者组合利用方法`all?`——另一个 Enumerable 的方法，来判断一列数是不是连续的。

![method example](http://www.blackbytes.info/wp-content/uploads/2016/03/each_cons1.png)

`each_cons` 返回大小是 `n` 的子数组，如果我们给的数组是 `[1, 2, 3]`，那么 `each_cons(2)` 会返回 `[[1, 2], [2, 3]]`。

**让我们看个例子**

```ruby
numbers = [3, 5, 4, 2]
numbers.sort.each_cons(2).all? { |x, y| x == y - 1 }
```

这段代码从排序数组开始，之后呼叫方法 `each_cons(2)`，返回一个 `Enumerator` 对象，再呼叫方法 `all?` 方法检查所有的元素是否符合条件（连续）。

再来一个例子，作者使用 `each_cons` 检查每个字母是否被相同的字母环绕（左右字母相同），比如：`xyx`。

```ruby
str = 'abcxyx'
str.chars.each_cons(3).any? { |a, b, c| a == c }
```

**更多的例子**

如果你想知道这个模式发生的频率，可以使用 `any?` 和 `count` 的方法计数，而不是获得 `true/false` 的结果。

作者发现更有趣的事情是实现 `each_cons` 方法。

```ruby
array = []
each do |element|
  array << element
  array.shift if array.size > n
  yield array.dup if array.size == n
end
```

> **注意：** 这段代码来自 Rubinius 的 `Enumerable` 的实现。你可以在[这里找到源码](https://github.com/rubinius/rubinius/blob/master/core/enumerable.rb#L482)。

这个实现首先新建了一个空的数组，之后使用 `each` 方法迭代每个元素。

知道这里，实现的内容都是比较普通的。之后向数组中添加元素，修剪数组（使用 Array#shift）如果数组的大小超过我们预期的。预期的数组大小是 `each_cons` 的参数。

之后，返回一个数组的 `dup` 如果数组的大小正好等于我们预期的数值。

作者认为这是一个天才的实现，因为it keeps a ‘sliding window’ sort of effect into our enumerable object, instead of having to mess around with array indexes.

---

翻译，为了阅读和练习。原文在这里[http://www.blackbytes.info/2016/03/enumerable-methods/](http://www.blackbytes.info/2016/03/enumerable-methods/)。


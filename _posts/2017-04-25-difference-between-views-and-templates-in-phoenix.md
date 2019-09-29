---
layout: post
date: 2017-04-25 21:19:00 +1000
modified: 2019-09-28 21:19:00 +1000
title: Phoenix 中 View 和 Template 的区别
---

原文 https://samueltthomas.com/difference-between-views-and-templates-in-phoenix

在常见的 MVC 框架中，view 和 template 一般是指的同一个事物。但是在 Phoenix 框架中，它们分别指代不同的组件。这个差异经常会误导从其它框架来的开发者。

在 Phoenix 的世界中，template 是包含 HTML 标识和一些动态 Elixir 代码的文件。我们用嵌入的 Elixir 编写 template，并以后缀为 `.html.eex` 的文件保存在目录 `web/templates` 中。当我们生成新的 Phoenix 程序时，默认的 home template 文件在 `web/templates/page/index.html.eex`。

如果你打开 `web/controllers/page_controller.ex` 你可以看到函数在调用这个 template

```elixir
def index(conn, _params) do
  render conn, "index.html"
end
```

实际上，这是在直接调用定义在 PageView 模块 `web/views/page_view.ex` 中的函数。当你打开那个文件时，你却看不到有函数定义。但是你在 iex 中运行 app，并输入 `MyApp.PageView.render("index.html", %{})`，你可以看到 template 文件的内容。魔幻的事情发生在这里。Phoenix 把 `web/templates/page/index.html.eex` 编译成 Elixir 代码并把它们作为一个函数添加到 PageView 模块中，像下面这样

```elixir
def render("index.html", _assigns) do
  "Compiled EEx template"
end
```

如果你把上面的代码复制到 `web/views/page_view.ex` 中，你会发现它覆盖掉了 template 编译生成的函数。

总之，Phoenix template 被编译成 rendering 函数并放到对应的 view 模块中。这个 template 的预编译机制是它（Phoenix template）速度很快的原因之一。我们可以在 view 模块中定义其它的 helper 函数，在渲染 template 之前用来改变数据。

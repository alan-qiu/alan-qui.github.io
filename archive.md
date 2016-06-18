---
layout: page
title: Archive
---

<ul class="post-list">
  {% for post in site.posts %}
  <li>
    <span class="home-post-list-date">{{ post.date | date: '%Y-%m-%d' }}</span>
    <span class="seperator">~</span>
    <a href="{{ post.url }}">{{ post.title }}</a>
  </li>
  {% endfor %}
</ul>

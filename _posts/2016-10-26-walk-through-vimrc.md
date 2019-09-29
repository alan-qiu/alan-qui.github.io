---
layout: post
date: 2016-10-26
modified: 2019-09-28
title: 面向 ruby 开发巡查 .vimrc 文件
tags: ["walk through", "ruby", "vimrc"]
---

原文 http://janjiss.com/walkthrough-of-my-vimrc-file-for-ruby-development/

有很多人希望使用 vim 作为他们的文本编辑器。但是有很多问题会吓退这些新来者，其中一个是为了更好的工作而编写自己的扩展配置文件。这就是作者编写这篇巡查自己的 .vimrc，解释文件每一行配置的原因。话说白了，这么做会让作者更好的明白自己的 vimrc 配置，并删除无用的配置。依据这个想法，让我们开始吧：

    set nocompatible " be iMproved

仅仅是告诉 vim 不需要兼容 vi。这一行是必需的。

    " For vundle
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#rc()

这几行是初始化 Vundle 插件需要的。This plugin is responsible for managing dependencies. Next lines are just plugin definitions, where the string is github repository.

    " Dependencies of snipmate
    Bundle "MarcWeber/vim-addon-mw-utils"
    Bundle "tomtom/tlib_vim"
    Bundle "honza/vim-snippets"

    " Snippets for our use :)
    Bundle 'garbas/vim-snipmate'

开始的几行配置了 snipmate 的依赖，snipmate 用来自动补全很多表达式。比如，你输入 `def<tab>`，就会自动补全成

```
def method_name

end
```

```
" Git tools
Bundle 'tpope/vim-fugitive'
```

有很多工具让 VIM 和 GIT 很好的配合。作者这里不展开细节，请阅读相关文档。

    " Dependency managment
    Bundle 'gmarik/vundle'

依赖管理插件本身。

    " Rails :/
    Bundle 'tpope/vim-rails.git'

有很多工具来方便 rails 的开发。作者会列出其中的一些。

    " Commenting and uncommenting stuff
    Bundle 'tomtom/tcomment_vim'

这个插件允许你注释／反注释你的代码块。作者一般使用 `gc` 来注释／反注释代码。

    " Molokai theme
    Bundle 'tomasr/molokai'

Molokai 样式。

    " Vim Ruby
    Bundle 'vim-ruby/vim-ruby'

Ruby 语法高亮。

    " Surround your code :)
    Bundle 'tpope/vim-surround'

Great plugin if you want to change braces to curly braces or p tag to div tag or any other combination that you might imagine. Make sure to check it out.

    " Every one should have a pair (Autogenerate pairs for "{[( )
    Bundle 'jiangmiao/auto-pairs'

自动补全括号。这是很多文本编辑器的默认行为。

    " Tab completions
    Bundle 'ervandew/supertab'

Tab 补全。当输入某些 vim 已经打开的内容，vim 会尝试自动补全方法的名称、变量等。

    " Fuzzy finder for vim (CTRL+P)
    Bundle 'kien/ctrlp.vim'

模糊搜索，与 Atom 和 Sublim 中的类似。按住 `CTRL+P` 并输入 `appctrlrsapp`，在搜索栏会出现 `app/controllers/application_controller` 的结果。非常方便。

    " For tests
    Bundle 'janko-m/vim-test'

这个是一个了不起的插件。你可以只配置并使用一个 test runner，而不是为你编写的代码找到所有的 test runners。对于 Elixir 和 Ruby，这个插件是开箱即用的。

    " Navigation tree
    Bundle 'scrooloose/nerdtree'

Nerd tree 是一个良好的文件系统导航侧边栏，和 Atom 和 Sublim 中的非常类似。

    " Dispatching the test runner to tmux pane
    Bundle 'tpope/vim-dispatch'

This plugin is used to dispatch the tests to tmux pane and then output to a horizontal split to bottom. Really handy.

    set tags=./tags; " Set tags directory

这行配置了 ctags 的目录。Ctags 对于文件导航有帮助。为了使用 ctags 工作与 ruby，需要一些设置的技巧。

    set autoindent " Auto indention should be on

自动缩进。仅仅是为了确保按下 enter 后，文本行会自动缩紧。

    " Ruby stuff: Thanks Ben :)
    " ================
    syntax on                 " Enable syntax highlighting
    filetype plugin indent on " Enable filetype-specific indenting and plugins

    augroup myfiletypes
        " Clear old autocmds in group autocmd!
        " autoindent with two spaces, always expand tabs
        autocmd FileType ruby,eruby,yaml,markdown set ai sw=2 sts=2 et
    augroup END
    " ================

为 ruby、eruby、yaml 和 markdown 文件显示设置两个空格的缩进。

    " Syntax highlighting and theme
    syntax enable

开启语法高亮。

    " Configs to make Molokai look great
    set background=dark
    let g:molokai_original=1
    let g:rehash256=1
    set t_Co=256
    colorscheme molokai

配置 Molokai 样式。

    " Show trailing whitespace and spaces before a tab:
    :highlight ExtraWhitespace ctermbg=red guibg=red
    :autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\\t/

红色高亮末尾的空白符如果你漏过了它们。

    " Lovely linenumbers
    set nu

启用行号。

    " My leader key
    let mapleader=","

作者使用 `,` 作为 mapleader，因为这么做在 OS X 下比较方便。

    " Searching
    set hlsearch

高亮搜索的内容。

set incsearch

Searches incremetally as you type.

    set ignorecase

忽略大小写。

    set smartcase

如果你以驼峰式输入，vim 会默认你在使用驼峰式。不然，vim 默认大小写不敏感。

    " Remove highlights with leader + enter
    nmap <Leader><CR> :nohlsearch<cr>

使用 `,Enter` 清除搜索时的高亮。

    " Buffer switching
    map <leader>p :bp<CR> " ,p previous buffer
    map <leader>n :bn<CR> " ,n next buffer
    map <leader>d :bd<CR> " ,d delete buffer

作者经常跳转、删除不同的 buffers。上面的配置解释了作者是怎么做的。

    map <Leader>c :call <CR>
    nmap <silent> <leader>c :TestFile<CR>
    nmap <silent> <leader>s :TestNearest<CR>

使用 `,c` 运行当前测试文件，使用 `,s` 运行光标所在的测试。

    map <leader>t :A<CR> " \t to jump to test file
    map <leader>r :r<cr> " \t to jump to related file

这些命令来自 rails-vim。允许作者跳转到对应的测试文件。

    set laststatus=2

列出当前文件的状态。

    " Don't be a noob, join the no arrows key movement
    inoremap  <Up>     <NOP>
    inoremap  <Down>   <NOP>
    inoremap  <Left>   <NOP>
    inoremap  <Right>  <NOP>
    noremap   <Up>     <NOP>
    noremap   <Down>   <NOP>
    noremap   <Left>   <NOP>
    noremap   <Right>  <NOP>

这些行的配置可以使你避免使用方向键移动。

    " Removing escape
    ino jj <esc>
    cno jj <c-c>
    vno v <esc>

在任何时候通过按下 `jj` 可以回到 normal 模式，而不用按下 ESC 键。

    " highlight the current line
    set cursorline
    " Highlight active column
    set cuc cul"

就像注释说的，高亮当前的行和列。

    " Tab completion
    set wildmode=list:longest,list:full
    set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

tab 自动补全。

    " Ruby hash syntax conversion
    nnoremap <F12> :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<return>

当你太懒而不想把旧语法的 Ruby Hash 改为新语法，这个命令会节省不少时间。

    map <leader>q :NERDTreeToggle<CR>

使用 `,q` 打开、关闭 Nerdtree。

    set clipboard=unnamed

每次复制、粘贴都会和系统粘贴板交互。非常有用。

    if has('nvim')
      let test#strategy = "neovim"
    else
      let test#strategy = "dispatch"
    endif

这几行设置测试策略。作者有时使用 neovim，看具体条件。在使用 vim 时，作者使用 dispatch 插件在 tmux 的 pane 中运行测试，使用 neovim 时，作者在内建的终端里运行测试。

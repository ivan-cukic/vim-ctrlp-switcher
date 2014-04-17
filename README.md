Description
===========

CtrlP extension for switching between similar files.

It has two modes, the choice

Mode 1 - Only the files with the same name (minus extension)
------------------------------------------------------------

In this mode, the plugin shows only the files that have
the same name as the current one, but have a different extension.
It also supports the 'private' class files.

For example, for Resources.h, it will show:

    Resources.cpp
    Resources_p.h
    Resources_p.cpp

The completion in this mode is instantaneous.

This mode is inspired by Derek Wyatt's fswitch plugin
(https://github.com/derekwyatt/vim-fswitch)
but a little bit more powerful.

![Switcher Mode 1](https://raw.githubusercontent.com/ivan-cukic/vim-ctrlp-switcher/master/images/switcher-mode1.gif)

Mode 2 - Files that match any of the words from the current file's name (Default)
---------------------------------------------------------------------------------

If you use the CamelCase, or the snake_case naming scheme for your files,
the plugin will extract the words from the current file's name
and search (using the find command) for the files that have any of those
words in their names.

For example, for ResourceActor.scala, it will return:

    ResourceTable.scala
    ResourceService.scala
    SomethingElseActor.scala

The completion is slower, so you are advised to localize the search
by defining the g:ctrlpswitcher_project_sources to point to the
directory under which you want to search.

![Switcher Mode 2](https://raw.githubusercontent.com/ivan-cukic/vim-ctrlp-switcher/master/images/switcher-mode2.gif)

Setting the mode
----------------

You can set it in your main .vimrc, or in a project's local .vimrc
(if you are using MarcWeber/vim-addon-local-vimrc.git or exrc)

    let g:ctrlpswitcher_mode = 1

or

    let g:ctrlpswitcher_mode = 2


Installation
============

You need the CtrlP extension by kien.

If you are using Vundle, just do this:

    let g:ctrlp_extensions = ['funky','switcher']
    Bundle 'kien/ctrlp.vim'
    Bundle 'ivan-cukic/vim-ctrlp-switcher'

Tasks for grabs
===============

Some things that would be nice additions to the plugin, if anybody is
willing to work on them:

- Make it obey wildignore when listing the files
- Make a similarity-based sort of the results

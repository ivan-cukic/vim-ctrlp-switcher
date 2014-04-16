Description
===========

CtrlP extension for switching between header and source files
which supports private classes (File_p.ext) used when implementing
the d-ptr pattern.

Essentially, it lists the files whose names start with the root of
the current file.

Example
-------

For example, if you are editing a file called Resource_p.h, it will
list Resource.h, Resource.cpp, ui_Resource.h, etc.

It is inspired by Derek's fswitch plugin (https://github.com/derekwyatt/vim-fswitch)
but a little bit more powerful.

Installation
============

You need the CtrlP extension by kien.

If you are using Vundle, just do this:

    let g:ctrlp_extensions = ['funky','switcher']
    Bundle 'kien/ctrlp.vim'
    Bundle 'ivan-cukic/vim-ctrlp-switcher'


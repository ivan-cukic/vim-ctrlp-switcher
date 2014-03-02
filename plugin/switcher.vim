" File: plugin/switcher.vim
" Description: a simple ctrlp.vim extension provides switching between .h,
" .cpp, _p.h, _p.cpp
" Author: Ivan Cukic <ivan.cukic___kde.org>
" License: The MIT License

command! -nargs=? CtrlPSwitch call ctrlp#switch#switch(<q-args>)


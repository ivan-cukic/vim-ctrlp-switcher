" File: plugin/switcher.vim
" Description: a simple ctrlp.vim extension provides switching between .h,
" .cpp, _p.h, _p.cpp
" Author: Ivan Cukic <ivan.cukic___kde.org>
" License: The MIT License

command! CtrlPSwitch        call ctrlp#init(ctrlp#switcher#id())
command! CtrlPSwitchBasic   let g:ctrlpswitcher_mode_override=1 | call ctrlp#init(ctrlp#switcher#id())
command! CtrlPSwitchFull    let g:ctrlpswitcher_mode_override=2 | call ctrlp#init(ctrlp#switcher#id())


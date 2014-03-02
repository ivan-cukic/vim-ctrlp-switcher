" =============================================================================
" File:          autoload/ctrlp/switcher.vim
" Description:   Switching between related header / impl files
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['switcher']

" Load guard
if ( exists('g:loaded_ctrlp_switcher') && g:loaded_ctrlp_switcher )
    \ || v:version < 700 || &cp
    finish
endif
let g:loaded_ctrlp_switcher = 1

let s:current_filename  = ''
let s:filepath          = ''
let s:filename_stripped = ''

" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
    \ 'init': 'ctrlp#switcher#init()',
    \ 'accept': 'ctrlp#switcher#accept',
    \ 'lname': 'long statusline name',
    \ 'sname': 'shortname',
    \ 'type': 'line',
    \ 'enter': 'ctrlp#switcher#enter()',
    \ 'exit': 'ctrlp#switcher#exit()',
    \ 'opts': 'ctrlp#switcher#opts()',
    \ 'sort': 0,
    \ 'specinput': 0,
    \ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#switcher#init()
    let l:current_dir = glob("`pwd`")
    " getcwd()
    let l:relative_path = s:filepath

    if s:filepath =~ l:current_dir.'.*'
        let l:relative_path = strpart(s:filepath, strlen(l:current_dir))
    endif

    return sort(
    \    filter(
    \        split(
    \            glob("`ls -1 ".l:relative_path."/".s:filename_stripped.".*  ".l:relative_path."/".s:filename_stripped."_p.* `"),
    \        "\n"),
    \    "'".l:current_dir."/'.v:val != '".s:current_filename."'")
    \)
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
" function! ctrlp#switcher#accept(mode, str)
"     " For this example, just exit ctrlp and run help
"     call ctrlp#exit()
"     help ctrlp-extensions
" endfunction

function! ctrlp#switcher#accept(mode, str)
    call ctrlp#acceptfile(a:mode, a:str)
endf


" (optional) Do something before enterting ctrlp
function! ctrlp#switcher#enter()
    let s:current_filename  = expand("%:p")
    let s:filepath          = expand("%:p:h")
    let s:filename_stripped = expand("%:t:r")

    if s:filename_stripped =~ '_p$'
        " Ok, we are in the private class
        let s:filename_stripped = strpart(s:filename_stripped, 0, strlen(s:filename_stripped) - 2)
    endif
endfunction


" (optional) Do something after exiting ctrlp
function! ctrlp#switcher#exit()
endfunction


" (optional) Set or check for user options specific to this extension
function! ctrlp#switcher#opts()
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#switcher#id()
  return s:id
endfunction

" vim:nofen:fdl=0:ts=4:sw=4:sts=4

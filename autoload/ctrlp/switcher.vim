" =============================================================================
" File:          autoload/ctrlp/switcher.vim
" Description:   Switching between related files
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

let s:current_file = ''
let s:current_path = ''

python << endpython

import vim
import os
import glob
import string
import re
import subprocess
from itertools import chain,groupby

ctrlpswitcher_underscorer1 = re.compile(r'(.)([A-Z][a-z]+)')
ctrlpswitcher_underscorer2 = re.compile('([a-z0-9])([A-Z])')

def ctrlpswitcher_separate_words(s):
    subbed = ctrlpswitcher_underscorer1.sub(r'\1_\2', s)
    return filter(None, ctrlpswitcher_underscorer2.sub(r'\1_\2', subbed).split('_'))

def ctrlpswitcher_flatten(items):
    return list(chain.from_iterable(items))

def ctrlpswitcher_count_occurences(words, string):
    lowered = string.lower()
    return len(filter(lambda word: word.lower() in lowered, words))

def ctrlpswitcher_get_vim_variable(variable, default_value):
    return vim.eval('exists(\'' + variable + '\') ? ' + variable + ' : ' + default_value)

endpython



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
    \ 'lname': 'file switcher',
    \ 'sname': 'switcher',
    \ 'type': 'path',
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
python << endpython

result = []

work_mode = int(ctrlpswitcher_get_vim_variable('g:ctrlpswitcher_mode', '2'))
work_mode_override = int(ctrlpswitcher_get_vim_variable('g:ctrlpswitcher_mode_override', '0'))

if work_mode_override > 0:
    vim.command('let g:ctrlpswitcher_mode_override=0')
    work_mode = work_mode_override

current_file = vim.eval('s:current_file')
current_path = vim.eval('s:current_path')

project_sources = ctrlpswitcher_get_vim_variable('g:ctrlpswitcher_project_sources', '\'\'')

if project_sources == "":
    project_sources = current_path

current_file = os.path.realpath(current_file)
current_path = os.path.realpath(current_path)
project_sources = os.path.realpath(project_sources)

if not current_path.endswith("/"):
    current_path += "/"

if not project_sources.endswith("/"):
    project_sources += "/"

if work_mode == 1:
    # Switching between the files with the same name
    # (with a few exceptions like _p and similar)

    (filepath, filename) = os.path.split(current_file)

    filename = os.path.splitext(filename)[0]
    filename = string.rsplit(filename, '_', 1)[0]

    result = glob.glob(filepath + "/" + filename + "*")
    result += glob.glob(filepath + "/*_" + filename + "*")

else:
    # Switching between the files that are similarly
    # named to the current one

    # result += [project_sources]
    # result += [current_path]

    current_file_len = len(current_file)

    (filepath, filename) = os.path.split(current_file)

    filename = os.path.splitext(filename)[0]
    filename = string.rsplit(filename, '_', 1)[0]

    words = ctrlpswitcher_separate_words(filename)

    # result += [filename + " " + str(words)]

    arguments = ctrlpswitcher_flatten( [ ["-o", "-iname", "*"+ word +"*"] for word in words ] )
    arguments.pop(0)
    arguments = ['find', project_sources, '-type', 'f', '('] + arguments + [')', '!', '-name', '.*']

    # result += [str(arguments)]

    files = subprocess.check_output(arguments).split('\n')
    files.sort(key = lambda item: abs(len(item) - current_file_len))

    result += files

try:
    result.remove(current_file)
except:
    pass

# lets try to trim the results
current_path=os.getcwd()
if not current_path.endswith('/'):
    current_path += '/'

current_path_len = len(current_path)
result = [ item[current_path_len:] if item.startswith(current_path) else item for item in result ]
result = filter(None, result)
#

vim.command("return " + str(result))

endpython
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
    let s:current_file  = expand("%:p")
    let s:current_path  = glob("`pwd`")
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

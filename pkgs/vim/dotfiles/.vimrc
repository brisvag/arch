" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
 
" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on
 
" Enable syntax highlighting
syntax on
colorscheme desert

" Non-retarded splitting (bottom-right instead of the opposite)
set splitbelow
set splitright

" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches. Also, search while typing
set hlsearch
set incsearch
 
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
 
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
 
" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
 
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
 
" Always display the status line, even if only one window is displayed
set laststatus=2
 
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
 
" Use visual bell instead of beeping when doing something wrong
set visualbell
 
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
 
" Enable use of the mouse for all mode. Press shift to highlight normally!
set mouse=a

" Automatically read external update to the file
set autoread

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
 
" Display line numbers on the left
set number

" Show context lines before and after the cursor
set so=10
 
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
 
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Split tabs navigation shorcuts
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
set shiftwidth=4
set tabstop=4

" Script sourcing
source /home/brisvag/.vim/scripts/diffchanges.vim

" Hide mode, since lightline is taking care of that now
set noshowmode

" Vim-Plug settings:
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-eunuch'
Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'rhysd/vim-grammarous'
Plug 'wakatime/vim-wakatime'
Plug 'kkoomen/vim-doge'
call plug#end()

" YouCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_server_python_interpreter = '/usr/bin/python3'

" add shortcut for GoTo command with \g
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Snippets settings
imap <Space><Space>     <Plug>(neosnippet_expand_or_jump)
smap <Space><Space>     <Plug>(neosnippet_expand_or_jump)
xmap <Space><Space>     <Plug>(neosnippet_expand_target)
let g:neosnippet#snippets_directory='~/myconfigs/snippets/'

" exchange ESC with CAPS, because we're lazy
" au VimEnter * :silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
" au VimLeave * :silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" SETTING FOR LATEX

" Enable latex filetype even for empty .tex files
let g:tex_flavor='latex'
" Vim-latex live preview
let g:livepreview_previewer = 'mupdf'
" Enable YouCompleteMe for latex
if !exists('g:ycm_semantic_triggers')
	let g:ycm_semantic_triggers = {}
endif
au Filetype tex let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
let g:vimtex_fold_enabled=1


" SETTINGS FOR PYTHON

" Python3 syntax highlight with python-mode
let g:pymode_python = 'python3'
let g:pymode_options = 1
let g:pymode_options_max_line_length = 110
let g:pymode_options_colorcolumn = 0
let g:pymode_indent = 1
let g:pymode_rope_complete = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_syntax = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_syntax_all = 1


" SETTINGS FOR PROSE
"au Filetype text setlocal formatoptions=aw2tq 
"au Filetype text setlocal laststatus=0 
"au Filetype text setlocal foldcolumn=5 
"au Filetype text setlocal nonumber
"au Filetype text setlocal foldmethod=expr
"au Filetype text setlocal foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1

" SETTINGS FOR VIM-NOTES

:let g:notes_directories = ['~/notes', '~/DnD/notes']
:let g:notes_suffix = '.txt'

" SETTINGS FOR GRAMMAROUS
" activates C-n, C-p, C-f, C-r to move and fix errors while in check and
" disables them on reset
let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
    nmap <buffer><C-n> <Plug>(grammarous-move-to-next-error)
    nmap <buffer><C-p> <Plug>(grammarous-move-to-previous-error)
    nmap <buffer><C-r> <Plug>(grammarous-remove-error) <bar> <Plug>(grammarous-move-to-next-error)
    nmap <buffer><C-f> <Plug>(grammarous-fixit) <bar> <Plug>(grammarous-move-to-next-error)
endfunction

function! g:grammarous#hooks.on_reset(errs) abort
    nunmap <buffer><C-n>
    nunmap <buffer><C-p>
    nunmap <buffer><C-r>
    nunmap <buffer><C-f>
endfunction

" BEHAVIOUR

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible
" Non-retarded splitting (bottom-right instead of the opposite)
set splitbelow splitright
" Use case insensitive search, except when using capital letters
set ignorecase smartcase
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
" Use visual bell instead of beeping when doing something wrong
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set visualbell
set t_vb= 
" Enable use of the mouse for all mode. Press shift to highlight normally!
set mouse=a
" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide
set shiftwidth=4
set tabstop=4
" clear last search highlight by pressing ESC in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
" set vim to use systemclipboard
set clipboard+=unnamedplus


" APPEARANCE

colorscheme desert
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2
" Display line numbers on the left
set number
" Show context lines before and after the cursor
set so=10


" MAPPINGS

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>
" Split tabs navigation shorcuts
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" PLUGINS

call plug#begin("$XDG_DATA_HOME/nvim/plugged")
" general
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-eunuch'
Plug 'wakatime/vim-wakatime'
Plug 'rhysd/vim-grammarous'
Plug 'wellle/targets.vim'
Plug 'lilydjwg/colorizer'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
" notes and wikis
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'vimwiki/vimwiki'
" languages
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'kkoomen/vim-doge'
" completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'Shougo/neco-syntax'
" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
call plug#end()


" PLUGIN SETTINGS

" DEOPLETE
let g:deoplete#enable_at_startup = 1
" close atuomatically on completion
if !exists('g:deoplete#omni#input_patterns')
	let g:deoplete#omni#input_patterns = {}
endif
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" enable completion with latex
call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})
" tab-complete
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<s-tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" LIGHTLINE
" hide mode, since lightline is taking care of that now
set noshowmode

" NEOSNIPPETS
imap <Space><Space>     <Plug>(neosnippet_expand_or_jump)
smap <Space><Space>     <Plug>(neosnippet_expand_or_jump)
xmap <Space><Space>     <Plug>(neosnippet_expand_target)
let g:neosnippet#snippets_directory="${XDG_DATA_HOME}/nvim/custom/snippets"

" VIMTEX and latex-related
" Enable latex filetype even for empty .tex files
let g:tex_flavor='latex'
" Vim-latex live preview
let g:livepreview_previewer = 'mupdf'
let g:vimtex_view_method = 'mupdf'

" PYTHON-MODE and python-related
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
let g:pymode_folding = 0

" SIMPYLFOLD
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0

" COLORIZER
let g:colorizer_maxlines = 1000

" VIM-NOTES
let g:notes_directories = ['~/notes', '~/DnD/notes']
let g:notes_suffix = '.txt'
let g:notes_tab_indents = 0
let g:notes_new_note_template = "${XDG_DATA_HOME}/nvim/custom/new_note_template.txt"

" VIMWIKI
let g:vimwiki_list = [
						\{
						\'path': '~/git/dndwiki/',
						\'path_html': '~/git/dndwiki/html/',
						\'syntax': 'default',
						\'ext': '.wiki',
						\'template_path': '~/git/dndwiki/templates',
						\'template_default': 'default',
						\'template_ext': '.html',
						\'auto_tags': 1,
						\'auto_diary_index': 1,
						\},
					\]
let g:vimwiki_table_mappings = 0
nmap <leader>wa :VimwikiAll2HTML<CR><CR>
nmap <leader>we <Plug>VimwikiSplitLink
nmap <leader>wq <Plug>VimwikiVSplitLink

" GRAMMAROUS
" activates C-n, C-p, C-f, C-r to move and fix errors while in check and
" disables them on reset
let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
    nmap <buffer><C-l> <Plug>(grammarous-move-to-next-error)
    nmap <buffer><C-p> <Plug>(grammarous-move-to-previous-error)
    nmap <buffer><C-o> <Plug>(grammarous-remove-error) <bar> <Plug>(grammarous-move-to-next-error)
    nmap <buffer><C-k> <Plug>(grammarous-fixit) <bar> <Plug>(grammarous-move-to-next-error)
endfunction
function! g:grammarous#hooks.on_reset(errs) abort
    nunmap <buffer><C-l>
    nunmap <buffer><C-p>
    nunmap <buffer><C-o>
    nunmap <buffer><C-k>
endfunction

" NERDTREE

" open nerdtree
map <C-n> :NERDTreeToggle<CR>
" automatically close vim if nerdtree is the only thing left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" pretty arrows
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'



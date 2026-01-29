" vim-plug auto-install
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
let plug_install = 0
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let plug_install = 1
endif

call plug#begin()

Plug 'tmhedberg/SimpylFold'
Plug 'Raimondi/delimitMate'
Plug 'nanotech/jellybeans.vim'
Plug 'hdima/python-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'pangloss/vim-javascript'
Plug 'mhinz/vim-startify'
Plug 'ap/vim-buftabline'
Plug 'Vimjas/vim-python-pep8-indent'

call plug#end()

if plug_install
  PlugInstall --sync
endif
unlet plug_install

set wildmenu
set number
set lazyredraw
set hidden
set foldlevelstart=99

set backspace=indent,eol,start
set expandtab
set shiftwidth=4
set softtabstop=4

set autoindent

augroup ac
    autocmd!
augroup END

filetype plugin indent on

autocmd FileType html setlocal shiftwidth=2 softtabstop=2 foldmethod=indent
autocmd FileType html.mustache setlocal shiftwidth=2 softtabstop=2 foldmethod=indent
autocmd FileType html.handlebars setlocal shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 softtabstop=2
autocmd FileType lua setlocal shiftwidth=2 softtabstop=2
autocmd FileType asm set noexpandtab softtabstop=0 shiftwidth=0 tabstop=8 fo-=t

syntax enable
colorscheme jellybeans

if has('win32')
    let $VIMHOME = expand('~/vimfiles')
else
    let $VIMHOME = expand('~/.config/nvim')
endif

set backup
set undofile
let &backupdir=$VIMHOME . '/var/backup//'
let &directory=$VIMHOME . '/var/swap//'
let &undodir=$VIMHOME . '/var/undo//'
autocmd ac BufWritePre * let &backupext = '=' . expand('%:p:gs?[:\/]?%?') . '~'

set clipboard=unnamed

set noerrorbells visualbell t_vb=
autocmd ac GUIEnter * set noerrorbells visualbell t_vb=

set textwidth=79
set formatoptions+=t
autocmd ac FileType gitcommit setlocal textwidth=72

set mouse=a

set foldmethod=indent
autocmd ac FileType c,cpp setlocal foldmethod=syntax
autocmd ac FileType javascript setlocal foldmethod=syntax

let mapleader = ' '

nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>

nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>
nnoremap <C-J> :b#<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>j :b#<CR>

nnoremap <Tab> :buffers<CR>:b<Space>

nnoremap <Leader><Space> za

nnoremap <F9> :cd %:p:h<CR>:pwd<CR>
nnoremap <F10> :e $MYVIMRC<CR>
autocmd ac BufWritePost init.vim source $MYVIMRC

nnoremap Y y$

cnoreabbrev W w

set cino+=l1

let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'

let g:python_highlight_all = 1

if has('win32')
    let g:netrw_list_hide='My\ Digital\ Editions/,Custom\ Office\ Templates/,My\ Music/,My\ Pictures/,My\ Videos/,desktop.ini'
    set wildignore+=My\ Digital\ Editions/,Custom\ Office\ Templates/,My\ Music/,My\ Pictures/,My\ Videos/,desktop.ini
endif

set sessionoptions-=options
set sessionoptions-=folds

let g:ctrlp_mruf_relative = 1
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_user_command = 'ag -i --nocolor --nogroup --hidden -g "" %s'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_reuse_window  = 'startify'

nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-l> :wincmd l<CR>

cmap w!! w !sudo tee > /dev/null %

let g:startify_custom_header = []
let g:startify_list_order = [['   Most recently used files:'], 'files', ['   Most recently used files in the current directory:'], 'dir', ['   My sessions:'], 'sessions', ['   My bookmarks:'], 'bookmarks']
let g:startify_enable_unsafe = 1

let g:startify_session_dir = $VIMHOME . '/session//'

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

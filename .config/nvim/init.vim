set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
 call dein#begin('~/.cache/dein')

 call dein#add('~/.cache/dein')

 call dein#add('tmhedberg/SimpylFold')
 "call dein#add('sudar/vim-arduino-syntax')
 "call dein#add('hail2u/vim-css3-syntax')
 "call dein#add('mattn/emmet-vim')
 "call dein#add('FelikZ/ctrlp-py-matcher')
 "call dein#add('kien/ctrlp.vim')
 call dein#add('Raimondi/delimitMate')
 "call dein#add('othree/html5.vim')
 call dein#add('nanotech/jellybeans.vim')
 call dein#add('hdima/python-syntax')
 call dein#add('octol/vim-cpp-enhanced-highlight')
 "call dein#add('4Evergreen4/vim-hardy')
 "call dein#add('pangloss/vim-javascript')
 "call dein#add('lepture/vim-jinja')
 "call dein#add('mustache/vim-mustache-handlebars')
 call dein#add('mhinz/vim-startify')
 "call dein#add('vim-scripts/CSS-one-line--multi-line-folding')
 "call dein#add('rizzatti/dash.vim')
 "call dein#add('harenome/vim-mipssyntax')
 call dein#add('ap/vim-buftabline')
 "call dein#add('ap/vim-readdir')

 call dein#add('Vimjas/vim-python-pep8-indent')

 call dein#local('~/.cache/dein/local')

 call dein#end()
 call dein#save_state()

 "let g:loaded_netrwPlugin = 1
endif

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
"autocmd BufNewFile,BufRead,BufReadPost *.s set syntax=mips

syntax enable

"if has('gui_running')
    colorscheme jellybeans
"endif

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

" if has('win32')
"     set guifont=DejaVu\ Sans\ Mono:h11
"     set guioptions-=m
"     set guioptions-=T
"     set guioptions-=r guioptions-=R
"     set guioptions-=r guioptions-=L
"     set guioptions-=b
"     set guioptions-=e
" else
"     set guifont=Hack\ Nerd\ Font:h12
" endif

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

" set viminfo+=n$VIMHOME/viminfo

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

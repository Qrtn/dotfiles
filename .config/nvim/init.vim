" ====================
" Plugins
" ====================
let data_dir = stdpath('data') . '/site'
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

" ====================
" General
" ====================
set number
set hidden
set mouse=a
set clipboard=unnamed
set noerrorbells visualbell
set sessionoptions-=options,folds

" ====================
" Indentation
" ====================
set expandtab
set shiftwidth=4
set softtabstop=4
set cino+=l1

" ====================
" Folding
" ====================
set foldmethod=indent
set foldlevelstart=99

" ====================
" Text width
" ====================
set textwidth=79
set formatoptions+=t

" ====================
" Backup/Undo
" ====================
let $VIMHOME = stdpath('config')
set backup undofile
let &backupdir=$VIMHOME . '/var/backup//'
let &directory=$VIMHOME . '/var/swap//'
let &undodir=$VIMHOME . '/var/undo//'

" ====================
" Appearance
" ====================
colorscheme jellybeans

" ====================
" Autocommands
" ====================
augroup vimrc
  autocmd!
  " Filetype-specific indentation
  autocmd FileType html,html.mustache,html.handlebars,javascript,css,lua setlocal shiftwidth=2 softtabstop=2
  autocmd FileType html,html.mustache setlocal foldmethod=indent
  autocmd FileType asm setlocal noexpandtab softtabstop=0 shiftwidth=0 tabstop=8 fo-=t
  " Filetype-specific folding
  autocmd FileType c,cpp,javascript setlocal foldmethod=syntax
  " Git commits
  autocmd FileType gitcommit setlocal textwidth=72
  " Backup extension with full path
  autocmd BufWritePre * let &backupext = '=' . expand('%:p:gs?[:\/]?%?') . '~'
  " Auto-reload vimrc
  autocmd BufWritePost init.vim source $MYVIMRC
augroup END

" ====================
" Keybindings
" ====================
let mapleader = ' '

" Buffer navigation
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>
nnoremap <C-J> :b#<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>j :b#<CR>
nnoremap <Tab> :buffers<CR>:b<Space>

" Window navigation
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-l> :wincmd l<CR>

" Folding
nnoremap <Leader><Space> za

" Misc
nnoremap <F9> :cd %:p:h<CR>:pwd<CR>
nnoremap <F10> :e $MYVIMRC<CR>
nnoremap Y y$
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
cnoreabbrev W w
cmap w!! w !sudo tee > /dev/null %

" ====================
" Plugin: python-syntax
" ====================
let g:python_highlight_all = 1

" ====================
" Plugin: vim-python-pep8-indent
" ====================
let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'

" ====================
" Plugin: delimitMate
" ====================
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" ====================
" Plugin: startify
" ====================
let g:startify_custom_header = []
let g:startify_list_order = [
  \ ['   Most recently used files:'], 'files',
  \ ['   Most recently used files in the current directory:'], 'dir',
  \ ['   My sessions:'], 'sessions',
  \ ['   My bookmarks:'], 'bookmarks'
  \ ]
let g:startify_enable_unsafe = 1
let g:startify_session_dir = $VIMHOME . '/session'

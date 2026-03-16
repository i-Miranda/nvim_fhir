"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                         "
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗                   "
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝                   "
"               ██║   ██║██║██╔████╔██║██████╔╝██║                        "
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║                        "
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗                   "
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝                   "
"                                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"Disable Vi compatibility
set nocompatible
set backspace=indent,eol,start
set hidden

"Indentation
set autoindent
"set cindent
set shiftwidth=4
set shiftround
set tabstop=4
set smarttab
"set expandtab

"Enable filetype detection
filetype on
filetype plugin on
filetype indent on

set number
set relativenumber
set textwidth=80
set nowrap
set signcolumn=number
set foldcolumn=1

set listchars=trail:%,eol:#
set nolist

"Hides '|' in vertical split
set fillchars+=vert:\

"Search options
set path+=**
set incsearch
set hlsearch
set ignorecase
set smartcase

set cursorline
set colorcolumn=80

set splitright splitbelow

set noerrorbells
set visualbell

set showcmd
set showmatch
set showmode

"Performance options
" Screen doesn't update during macro or script execution
"set lazyredraw

set history=1000

set undodir=~/.config/nvim/backup
set undofile
set undoreload=10000

set wildmenu
set wildmode=longest:list,full
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

"KEYMAPS {{{
nnoremap <space> <Nop>
let mapleader = " "

"Center cursorline
nnoremap j jzz
nnoremap k kzz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap H Hzz
vnoremap H Hzz
nnoremap L Lzz
vnoremap L Lzz
nnoremap gg ggzzzv
nnoremap gd gdzzzv:nohlsearch<CR>
nnoremap gD gDzzzv:nohlsearch<CR>

nnoremap o o<esc>
nnoremap O O<esc>
nnoremap <leader>o mojdd`o
nnoremap <leader>O mOkdd`O

nnoremap <leader>cc ~h
vnoremap <leader>cc ~

nnoremap <leader>nh :nohlsearch<CR>

"Window navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-H> <c-w>h:vert res 9999<CR>
nnoremap <c-L> <c-w>l:vert res 9999<CR>
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"Window splits
nnoremap <leader>- :split<CR>
nnoremap <leader>\ :vsplit<CR>
nnoremap <leader>l :vert res 9999<CR>
nnoremap <leader>k <c-w>_
nnoremap <leader><space> <c-w>=
nnoremap <leader>q :q<CR>

nnoremap <leader>ee :enew<CR>

nnoremap <leader>bb :rightb vnew<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bq :bun<CR>
nnoremap <leader>bd :bdel<CR>

nnoremap <leader>tt :tabnew<CR>
nnoremap <leader>tT :tabnew %<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>
nnoremap <leader>tq :tabclose<CR>
nnoremap <leader>to :tabonly<CR>

nnoremap <leader>ff :FZF<CR>
nnoremap <leader>fz :find<space>
nnoremap <leader>fb :ls<CR>:b<space>
nnoremap <leader>fo :Lexplore<CR>:wincmd L<CR>21<c-w><CR>
nnoremap <leader>fO :Explore<CR>
nnoremap <leader>fm :marks<CR>:normal! `
nnoremap <leader>fr :reg<CR>:normal! "
nnoremap <leader>ft :tags<CR>
nnoremap <leader>fu :undolist<CR>:u<space>
nnoremap <leader>fv :find ~/.config/nvim/vimrc<CR>

nnoremap <leader>gd *<c-]>n:nohl<CR>zz

map Y y$

nnoremap <leader>sl m1:bufdo execute "set list"<CR>'1zz
nnoremap <leader>snl m1:bufdo execute "set nolist"<CR>'1zz
nnoremap <leader>sf :set foldenable<CR>zz
nnoremap <leader>snf :set nofoldenable<CR>zz

" added :noh to remove highlight at the end
nnoremap <leader>so :w<CR>:so<space>%<CR>:noh<CR>

inoremap jj <esc>
" }}}

"VIMSCRIPT {{{
augroup filetype_vim
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup filetype_c
    autocmd FileType c setlocal foldmethod=syntax
    autocmd FileType c setlocal nofoldenable
	"set tags+=/usr/local/include/**/tags
augroup END

augroup filetype_cpp
    autocmd FileType cpp setlocal foldmethod=syntax
    autocmd FileType cpp setlocal nofoldenable
	"set tags+=/usr/local/include/**/tags
augroup END

augroup filetype_man
    autocmd FileType man wincmd L
    autocmd FileType man set wrap
    autocmd FileType man set linebreak
    autocmd FileType man set colorcolumn=0
    autocmd FileType man tabnew %
    autocmd FileType man tabprev
augroup END

augroup filetype_netrw
	autocmd FileType netrw set number
	autocmd FileType netrw set relativenumber
augroup END

augroup help_vert
    autocmd FileType help wincmd L
    autocmd FileType help set wrap
    autocmd FileType help set linebreak
    autocmd FileType help set colorcolumn=0
    autocmd FileType help tabnew %
    autocmd FileType help tabprev 
augroup END

" Display cursorline in active window.
augroup cursor_off
    autocmd WinLeave * set nocursorline 
    autocmd WinEnter * set cursorline 
augroup END

"Create the 'tags' file.  (ctags required: brew install ctags)
command! MakeTags !ctags -R .
    "NOW WE CAN:
    " - Use ^] to jump to tag under cursor
    " - Use g^] for ambiguous tags
    " - Use t^ to jump back up the tag stack
" }}}

" C SPECIFIC {{{
" this isn't working
syn keyword cType t_list
" this is
let c_functions = 1
let c_function_pointers = 1
let c_syntax_for_h = 1
" }}}

" 42 SPECIFIC {{{
let g:user42 = 'ivmirand'
let g:mail42 = 'ivmirand@student.42madrid.com'

nnoremap <leader>std :Stdheader<CR>
" }}}

"STATUS LINE {{{
" Clear status line when vimrc is reloaded.
set ruler
set statusline=

" Status line left side.
set statusline+=\ %n\ %F\ %m\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ %y\ ascii:\%b\ hex:\0x%B\ %l\:%c\ %p%%

" Show the status on the second to last line.
set laststatus=2
" }}}

" PLUGINS {{{
set rtp+=/bin/fzf
runtime ftplugin/man.vim
" }}}

" netrw {{{
" FILE BROWSING:
" Tweaks for browsing:
" let g:netrw_banner=0  "disable banner
let g:netrw_browse_split=4 "open in prior window
let g:netrw_altv=0 "open splits to the left
let g:netrw_liststyle=3 "tree view
let g:netrw_winsize=-20
"let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'
    " NOW WE CAN:
    " - edit a folder to open a file browser
    " - <CR>/v/t to open in an h-split/v-split/tab
    " - check |netrw-browse-maps| for more mappings
" }}}

"" NICE TO KNOW {{{
"set omnifunc=syntaxcomplete#Complete
"" AUTOCOMPLETE:
"    " The good stuff is documented in |ins-completion|
"    " HIGHLIGHTS:
"    " - ^x^n for JUST this file
"    " - ^x^f for filenames in path
"    " - ^x^] for tags only
"    " - ^n for anything specified by the 'complete' option
"
"    " NOW WE CAN:
"    " - Use ^n and ^p to go back and forth in the suggestion list
"" }}}

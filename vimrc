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

set undodir=~/.vim/backup
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
nnoremap <leader>fv :find ~/.vim/vimrc<CR>

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

" STYLE {{{
syntax enable

" Use a line cursor within insert mode and a block cursor everywhere else.
    "   Reference chart of values:
    "   Ps = 0  -> blinking block.
    "   Ps = 1  -> blinking block (default).
    "   Ps = 2  -> steady block.
    "   Ps = 3  -> blinking underline.
    "   Ps = 4  -> steady underline.  "   Ps = 5  -> blinking bar (xterm).
    "   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[2 q"

set t_Co=256
set termguicolors
colorscheme default
set background=dark

" rosewater = #F2D5CF
" flamingo = #EEBEBE
" pink = #F4B8E4
" mauve = #CA9EE6
" red = #E78284
" maroon = #EA999C
" peach = #EF9F76
" yellow = #E5C890
" green = #A6D189
" teal = #81C8BE
" sky = #99D1DB
" sapphire = #85C1DC
" blue = #8CAAEE
" lavender = #BABBF1
 
" text = #C6D0F5
" subtext1 = #B5BFE2
" subtext0 = #A5ADCE
" overlay2 = #949CBB
" overlay1 = #838BA7
" overlay0 = #737994
" surface2 = #626880
" surface1 = #51576D
" surface0 = #414559

" base = #303446
" mantle = #292C3C
" crust = #232634

highlight ColorColumn guibg=#737994
highlight Comment cterm=italic guifg=#CA9EE6
highlight Constant guifg=#F4B8E4
highlight CurSearch guifg=#303446 guibg=#EA999C 
highlight CursorLine cterm=none guibg=#51576D
highlight CursorLineNr cterm=bold,italic guifg=#85C1DC guibg=#414559
highlight Error cterm=bold,italic guifg=#F2D5CF guibg=#EA999C
highlight ErrorMsg cterm=bold,italic guifg=#F2D5CF guibg=#EA999C
highlight FoldColumn guifg=#737994 guibg=#EEBEBE
highlight Folded cterm=bold,italic guifg=#414559 guibg=#EEBEBE
highlight Identifier cterm=bold guifg=#99D1DB
highlight IncSearch guifg=#303446 guibg=#F2D5CF 
highlight LineNr guifg=#414559 guibg=#CA9EE6
highlight MatchParen guifg=#303446 guibg=#EA999C
highlight NonText guifg=#737994 guibg=#303446
highlight Normal guifg=#C6D0F5 guibg=#303446
highlight Pmenu guifg=#414559 guibg=#CA9EE6
highlight PmenuSel guifg=#303446 guibg=#EEBEBE
highlight PmenuSBar guibg=#414559
highlight PmenuThumb guibg=#85C1DC 
highlight PreProc guifg=#99D1DB
highlight Search guifg=#303446 guibg=#F2D5CF
highlight Special guifg=#E5C890
highlight Statement guifg=#EEBEBE
highlight StatusLine guibg=#303446 guifg=#EEBEBE
highlight StatusLineNC guibg=#303446 guifg=#CA9EE6
highlight StatusLineTerm guifg=#303446 guibg=#EEBEBE
highlight StatusLineTermNC cterm=italic guifg=#303446 guibg=#EEBEBE
highlight TabLine cterm=none guifg=#303446 guibg=#EEBEBE
highlight TabLineFill guifg=#EEBEBE
highlight TabLineSel cterm=bold,italic guifg=#232634 guibg=#CA9EE6
highlight Title guifg=#232634
highlight Type cterm=bold guifg=#A6D189
highlight Underlined guifg=#E78284
highlight VertSplit guifg=#CA9EE6
highlight Visual guibg=SlateGray
highlight WildMenu cterm=bold guifg=#85C1DC guibg=#303446

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

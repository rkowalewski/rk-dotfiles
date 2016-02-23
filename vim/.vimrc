set nu
set history=700				" Sets how many lines of history VIM has to remember

colo delek
syntax on
filetype plugin indent on

set showmode

set autoindent
set smartindent
set backspace=eol,start,indent

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set ruler

set number
set ignorecase
set smartcase
set hlsearch
set nowrap
set laststatus=2
set cmdheight=2
set encoding=utf-8

"Pathogen
execute pathogen#infect()

" NerdTree
let g:nerdtree_tabs_open_on_console_startup=1
map <F2> :NERDTreeToggle<CR>
let g:NERDTreeDirArrows=0

" astyle AutoFormat
map <F3> :%!astyle -s2<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"vim-colors-solarized
set background=dark
colorscheme solarized

" spell
set spell spelllang=en_us

"Gutentags
:call pathogen#helptags() 
set statusline+=%{gutentags#statusline()}

" ================== Mouse works inside VIM ==============
set mouse=a

"====== Custom Mappings ====================
nnoremap ü <C-]>

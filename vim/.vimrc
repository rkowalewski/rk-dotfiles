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
set laststatus=2 "display always status line
set cmdheight=2
set encoding=utf-8

"Status Line
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines

" Vim splits to the right and below
set splitbelow
set splitright

"Pathogen
let g:pathogen_disabled = []
" vim-gutentags plugin requires at least version 7.4
if v:version < '704'
  call add(g:pathogen_disabled, 'vim-gutentags')
endif


execute pathogen#infect()

" NerdTree
let g:nerdtree_tabs_open_on_console_startup=0
let g:NERDTreeDirArrows=0
map <F2> :NERDTreeToggle<CR>

" astyle AutoFormat
map <F3> :%!astyle --style=stroustrup -j -H -p -s2 -k2 -W2 -xC79 -xL -z2 -Y -m0<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
:let g:syntastic_loc_list_height=5

"vim-colors-solarized
set background=dark
colorscheme solarized

" spell
set spell spelllang=en_us

" Gutentags
" :call pathogen#helptags() 
" set statusline+=%{gutentags#statusline()}

" ================== Mouse works inside VIM ==============
set mouse=a

"====== Custom Mappings ====================

" Map Leader
let mapleader = ","

" navigate ctags
nnoremap ü <C-]>

" navigate panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>cd :cd %:p:h<CR>
noremap <leader>pp :echo expand('%:p')<CR>

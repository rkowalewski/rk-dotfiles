"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pathogen Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Use pathogen to inject all plugins
let g:pathogen_disabled = []
" vim-gutentags plugin requires at least version 7.4
if v:version < '704'
   call add(g:pathogen_disabled, 'vim-gutentags')
   endif

execute pathogen#infect()

" Enable file type detection
filetype on
filetype plugin on
filetype indent on
syntax on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
" However use it only if not running TMUX

if exists('$TMUX')
  " allows cursor change in tmux mode
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

  set clipboard=unnamed           " ┐
                                  " │ Use the system clipboard
  if has("unnamedplus")           " │ as the default register.
      set clipboard+=unnamedplus  " │
  endif
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Don’t add empty newlines at the end of files
set binary
set noeol

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline

" Show “invisible” characters
set list listchars=tab:▸\ ,trail:·,nbsp:_

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points
set tw=78


" ================ Indentation ======================
set autoindent
set smartindent
set smarttab
" 1 tab == 2 spaces
set tabstop=2                  " ┐
set softtabstop=2              " │ Set global <TAB> settings.
set shiftwidth=2               " │
set expandtab                  " ┘



" " ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set foldenable        "fold by default
set foldlevelstart=10   " open most folds by default

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ============= Formatting of Text ===================
if executable('par')
  set formatprg=par\ -w80
endif

" ================ Search ===========================
"
" Highlight dynamically as pattern is typed
set incsearch
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" ...unless we type a capital
set smartcase

" Add the g flag to search/replace by default
" set gdefault

" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
set ttymouse=xterm2
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd

" Vim splits to the right and below
set splitbelow
set splitright

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim/undo
    set undofile
catch
endtry

augroup configgroup
  autocmd!
  autocmd VimEnter * highlight clear SignColumn
  autocmd FileType java setlocal noexpandtab
  autocmd FileType java setlocal list
  autocmd FileType java setlocal listchars=tab:+\ ,eol:-
  autocmd FileType java setlocal formatprg=par\ -w80\ -T4
  autocmd FileType ruby setlocal tabstop=2
  autocmd FileType ruby setlocal shiftwidth=2
  autocmd FileType ruby setlocal softtabstop=2
  autocmd FileType ruby setlocal commentstring=#\ %s
  autocmd FileType python setlocal commentstring=#\ %s
  autocmd BufEnter *.cls setlocal filetype=java
  autocmd BufEnter *.zsh-theme setlocal filetype=zsh
  autocmd BufEnter Makefile setlocal noexpandtab
  autocmd BufEnter *.sh setlocal tabstop=2
  autocmd BufEnter *.sh setlocal shiftwidth=2
  autocmd BufEnter *.sh setlocal softtabstop=2
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  " Treat .tex files as tex
  autocmd BufRead,BufNewFile *.tex set filetype=tex
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Solarzied Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256                   " Enable full-color support.

" auto detect light or dark background
let iterm_profile = $ITERM_PROFILE
if iterm_profile == "light"
    set background=light
else
    set background=dark
endif

if !has("gui_running")
  " let g:solarized_contrast = "high"
  let g:solarized_termtrans = 1
  let g:solarized_termcolors = 256
  " let g:solarized_visibility = "high"
endif

colorscheme solarized          " Use custom color scheme.


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "let g:syntastic_always_populate_loc_list = 0
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_loc_list_height = 5
  let g:syntastic_c_check_header = 1
  let g:syntastic_cpp_check_header = 1

"  let g:syntastic_html_checkers = [ "jshint" ]
"  let g:syntastic_javascript_checkers = [ "jshint" ]

  let g:syntastic_debug=0
" Disable syntax checking by default.

"let g:syntastic_mode_map = {
"    \ "active_filetypes": ["c", "cpp"],
"    \ "mode": "active",
"    \ "passive_filetypes": []
"\}

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Clang Format
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:clang_format#detect_style_file = 1
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ü <C-]>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" let g:Powerline_symbols = 'fancy'
" enable syntastic extension with airline
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline#enable#fugitive=1
let g:airline#enable#syntastic=1
let g:airline#enable#bufferline=1

let g:airline#extensions#syntastic#enabled=1


" ----------------------------------------------------------------------
" | Automatic Commands                                                 |
" ----------------------------------------------------------------------

if has("autocmd")
    " Autocommand Groups.
    " http://learnvimscriptthehardway.stevelosh.com/chapters/14.html

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically reload the configurations from
    " the `~/.vimrc` file whenever they are changed.

    augroup auto_reload_vim_configs

        autocmd!
        autocmd BufWritePost vimrc source $MYVIMRC

    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically strip the trailing
    " whitespaces when files are saved.

    augroup strip_trailing_whitespaces

        " List of file types that use the trailing whitespaces:
        "
        "  * Markdown
        "    https://daringfireball.net/projects/markdown/syntax#block

        let excludedFileTypes = [
            \ "markdown",
            \ "mkd.markdown"
        \]

        " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        " Only strip the trailing whitespaces if
        " the file type is not in the excluded list.

        autocmd!
        autocmd BufWritePre * if index(excludedFileTypes, &ft) < 0 | :call StripTrailingWhitespaces()

    augroup END
endif

" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! StripTrailingWhitespaces()

    " Save last search and cursor position.

    let searchHistory = @/
    let cursorLine = line(".")
    let cursorColumn = col(".")

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Strip trailing whitespaces.

    %s/\s\+$//e

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Restore previous search history and cursor position.

    let @/ = searchHistory
    call cursor(cursorLine, cursorColumn)


endfunction

function! GetGitBranchName()

    let branchName = ""

    if exists("g:loaded_fugitive")
        let branchName = "[" . fugitive#head() . "]"
    endif

    return branchName

endfunction


function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------

" Use a different mapleader (default is "\").

let mapleader = ","

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,* ] Search and replace the word under the cursor.

nmap <leader>* :%s/\<<C-r><C-w>\>//<Left>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,cs] Clear search.

map <leader>cs <Esc>:noh<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,l ] Toggle `set list`.

nmap <leader>l :set list!<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,n ] Toggle `set relativenumber`.

let g:NumberToggleTrigger="<leader>n"

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,ts] Toggle Syntastic.

nmap <leader>ts :SyntasticToggleMode<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,v ] Make the opening of the `.vimrc` file easier.

nmap <leader>v :vsp $MYVIMRC<CR>


" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,v ] Make the opening of the `.vimrc` file easier.

nmap <F4> :TagbarToggle <CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [,W ] Sudo write.

map <leader>W :w !sudo tee %<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" [@] Apply Macro O@] Apply Macro Over Visual Range
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

highlight Cursor guifg=black guibg=white

" ----------------------------------------------------------------------
" | Local Settings                                                     |
" ----------------------------------------------------------------------

" Load local settings if they exist.
"
" [!] The following needs to remain at the end of this file in
"     order to allow any of the above settings to be overwritten
"     by the local ones.

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
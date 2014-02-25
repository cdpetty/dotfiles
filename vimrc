" The absolutes
set nocompatible
let mapleader = ","

" set up pathogen
execute pathogen#infect()
filetype plugin indent on

" Line number configuration
set number
set relativenumber

" Tabspace, etc
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" Save my work
au FocusLost * :wa

" Learn to use hjkl
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Key mappings
nnoremap ; :
nnoremap <leader><space> :noh<cr>

" syntax highlighting
syntax enable

" improve word searching
set incsearch
set showmatch
set hlsearch

" only check for case if search string has capital letters
set ignorecase
set smartcase

" line wrapping
set wrap
set textwidth=0

" keep the working line in context
set scrolloff=2

" Stop littering my working dir
" set nobackup

" colorscheme
set t_Co=256
set background=dark
colorscheme molokai 

" Rainbow Parenthesis colors
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

" Set paste to F2
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" vim-airline (statusbar)
set laststatus=2
let g:airline_theme='claytokai'
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
set ttimeoutlen=50
function! AirlineInit()
  call airline#parts#define_accent('%f','red')
  let g:airline_section_a = airline#section#create(['mode'])
  let g:airline_section_b = airline#section#create_left(['r:%l', 'c:%c'])
  let g:airline_section_c = airline#section#create(['%f ', 'readonly'])
  let g:airline_section_x = airline#section#create(['filetype'])
  let g:airline_section_y = '%P'
  let g:airline_section_z = '%{getcwd()}' " airline#section#create(['%{getcwd()}'])
endfunction
autocmd VimEnter * call AirlineInit()

" END

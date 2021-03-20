syntax on
set guicursor=
set scrolloff=12
set relativenumber
set nu
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nohlsearch
set incsearch
set signcolumn=yes
set backspace=indent,eol,start
set cul
set sidescroll=15
set list "to show the tab lines in the currentline"
set listchars=tab:>-,trail:- "using arrow and dashes to represent tabs and trailing white spaces"
set iskeyword+=- "adding  + from words to consider words with - as one single words"
set iskeyword-=_ "removing _ from words to consider words with _ as two different words"
"set ga  setting g flag by default for substitute"
"set nocompatible " option requirement for vim polyglot
filetype plugin on
set tw=110 "line length above which to break a line in insert mode"


" setting the leader key to space
let mapleader = " "

" open vertical explorer in normal mode
nnoremap <leader>pv :Vex<CR>

" word wrap remap
nnoremap <leader>wr :set wrap linebreak<CR>

" Remap for selecting and moving multiple lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

call plug#begin('~/.vim/plugged')
Plug 'raimondi/delimitmate'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'morhetz/gruvbox'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'preservim/nerdcommenter'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-surround'
Plug 'sainnhe/edge'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'pangloss/vim-javascript'
Plug 'tommcdo/vim-lion'
Plug 'yuttie/comfortable-motion.vim'
"Plug 'sheerun/vim-polyglot'
call plug#end()



let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]


" colorscheme definition
if has('termguicolors')
    set termguicolors
endif
let g:edge_style = 'neon'
"let g:edge_enable_italic = 1
let g:edge_disable_italic_comment = 1
let g:edge_cursor = 'red'
let g:edge_transparent_background = 1 "to use the transparent background"
let g:edge_current_word = 'grey background'
colorscheme edge
let g:rainbow_active = 1
let g:airline_theme = 'edge'

" Specifying the highlight color
"hi Visual guibg=green guifg=wheat
"since the terminal is having gui, we're setting the gui colors
hi Visual  guifg=#EFD469 guibg=#373D3F gui=none
hi Visual cterm=NONE ctermfg=yellow ctermbg=red

" Enabling rainbow mode parenths, square braces & curly braces
augroup rainbow_lisp
      autocmd!
      autocmd FileType lisp,clojure,scheme,javascript,python,c RainbowParentheses
augroup END

augroup rainbow_group
    au! VimEnter * nested RainbowParentheses
augroup end

" Setting up a new command called Prettier.
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Prettier command remap to CTRL + f
inoremap <C-f> <esc>:Prettier<CR>a

" Open the autocomplete remap using ctrl space
inoremap <silent><expr> <c-space> coc#refresh()
" inoremap <silent><expr> <NUL> coc#refresh()

" Remap to open the file tree
nnoremap <leader>ft :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" Remap to surrounding brackets using \
nnoremap \p bi(<Esc>ea)<Esc>
nnoremap \c bi{<Esc>ea}<Esc>



" Fuzzy finder remaps for fzf

nnoremap <C-p> :GFiles<CR>
nnoremap <leader>ff :Files<CR>


function! s:check_back_space() abort
  let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" remap tab to access and traverse the autocomplete dropdown
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" remap enter as selecting the first autocomplete suggestion and executing it.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" remap for moving across the open splits without pressing CTRL-w each time
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>


" Display buffers in the airline
"let g:airline#extensions#tabline#enabled = 1

syntax on
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
set undodir=~/.vim/undodir
set noswapfile
set nobackup
set undofile
set cul
set sidescroll=15
set list "to show the tab lines in the currentline"
set listchars=tab:>-,trail:- "using arrow and dashes to represent tabs and trailing white spaces"
set iskeyword+=- "adding  + from words to consider words with - as one single words"
set iskeyword-=_ "removing _ from words to consider words with _ as two different words"
"set colorcolumn=100
"highlight colorcolumn guibg=red
"set ga  setting g flag by default for substitute"
"set nocompatible " option requirement for vim polyglot
filetype plugin on
set tw=150 "line length after which to break a line in insert mode"
set nowrap
set pyxversion=3
"set guifont=Fira\ Code\ Nerd\ Font\ h20

" colorscheme definition
if has('termguicolors')
    set termguicolors
endif

"Important to set these for python linter used by coc
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

"let g:loaded_python_provider = 0
"let g:loaded_python3_provider = 1

" setting the leader key to space
let mapleader = " "

" open vertical explorer in normal mode
nnoremap <leader>pv :NERDTreeToggle<CR>

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
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tpope/vim-surround'
Plug 'sainnhe/edge'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'pangloss/vim-javascript'
Plug 'tommcdo/vim-lion'
Plug 'yuttie/comfortable-motion.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'preservim/nerdtree' 
Plug 'ThePrimeagen/vim-be-good'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
"Plug 'natebosch/vim-lsc'
"Plug 'natebosch/vim-lsc-dart'
"Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'Eandrju/cellular-automaton.nvim'
Plug 'dense-analysis/ale'
call plug#end()

" Always install nerd tree after the major plugins

" Keeping the sign column gutter open for Ale (remember to set the diagnostic.displayByAle in CocConfig)
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1

nnoremap <leader>ll :ALEPopulateQuickfix<CR>


let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" nerd tree expand and collapse icons
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '🔽'
let NERDTreeShowHidden = 1


let g:edge_style = 'neon'
"let g:edge_enable_italic = 1
let g:edge_disable_italic_comment = 1
let g:edge_cursor = 'red'
let g:edge_menu_selection_background='purple'
let g:edge_transparent_background = 1 "to use the transparent background"
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
      autocmd FileType lisp,clojure,scheme,javascript,typescript,python,c RainbowParentheses
augroup END

augroup rainbow_group
    au! VimEnter * nested RainbowParentheses
augroup end


" Setting up a new command called Prettier.
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0


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



" Fuzzy finder remaps for telescope

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


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
nnoremap <C-l> <C-w><C-l>


" navigate through the quick fix lists
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>


" Display buffers in the airline
let g:airline#extensions#tabline#enabled = 1


" Undo tree remap: allows me to open with U and shift window focus to undotree split
nnoremap U :UndotreeToggle<CR><C-w>h


" Setting custom airline symbol
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif



let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = '☰'
"let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

" Coc remaps for commands
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

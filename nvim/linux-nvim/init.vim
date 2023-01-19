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
"Plug 'nvim-lua/completion-nvim'
"Plug 'kabouzeid/nvim-lspinstall'
"Plug 'dart-lang/dart-vim-plugin'
"Plug 'thosakwe/vim-flutter'
"Plug 'natebosch/vim-lsc'
"Plug 'natebosch/vim-lsc-dart'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'Eandrju/cellular-automaton.nvim'
"Plug 'dense-analysis/ale'
Plug 'mhartington/oceanic-next'
call plug#end()

" Always install nerd tree after the major plugins

" Keeping the sign column gutter open for Ale (remember to set the diagnostic.displayByAle in CocConfig)
"let g:ale_sign_column_always = 1
"let g:airline#extensions#ale#enabled = 1

"nnoremap <leader>ll :ALEPopulateQuickfix<CR>


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
colorscheme OceanicNext
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
let g:rainbow_active = 1
let g:airline_theme = 'oceanicnext'

" Make the bg transparent
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE

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

set encoding=utf-8

set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300


" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  "nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  "inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  "inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  "vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
"
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


lua << EOF

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false
  }
)
EOF


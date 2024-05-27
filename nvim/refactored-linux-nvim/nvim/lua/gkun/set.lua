vim.g.mapleader = " "

vim.opt.scrolloff = 15
vim.opt.nu = true
vim.opt.relativenumber = true

vim.wo.wrap = false
vim.opt.encoding = "utf-8"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.cmd("set clipboard=unnamedplus")
--vim.cmd [[au TextYankPost * silent! lua vim.highlight.on_yank()]]

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = '*',
})

--vim.opt.wrap = false


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.sidescroll = 15


vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-" }

vim.opt.iskeyword:append('-') -- adding  + from words to consider words with - as one single words"
vim.opt.iskeyword:remove('_') -- removing _ from words to consider words with _ as two different words


vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")


vim.opt.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300


vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python3'

vim.g.rustfmt_autosave = 1

--vim.g.rainbow#max_level = 16
--vim.g.rainbow#pairs = "[['(', ')'], ['[', ']'], ['{', '}']]"

-- nerd tree expand and collapse icons
vim.g.NERDTreeDirArrowExpandable = '▶'
vim.g.NERDTreeDirArrowCollapsible = '🔽'
vim.g.NERDTreeShowHidden = 1


vim.g.airline_theme = 'oceanicnext'

-- show the open buffers tab
vim.g["airline#extensions#tabline#enabled"] = 1

-- show only one global statusline at the bottom of the screen
vim.opt.laststatus = 3
-- remove the highlight window separators between two buffer splits for a cleaner look
vim.cmd[[highlight WinSeparator guibg=None]]

-- options about the statusline representation
vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''
vim.g.airline_symbols.branch = ''
vim.g.airline_symbols.readonly = ''
vim.g.airline_symbols.linenr = '☰'
vim.g.airline_symbols.maxlinenr = ''
vim.g.airline_symbols.dirty = '⚡'

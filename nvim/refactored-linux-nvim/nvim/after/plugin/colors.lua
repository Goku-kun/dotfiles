vim.cmd.colorscheme('OceanicNext')
--vim.cmd('colorscheme OceanicNext')
vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
vim.cmd('hi LineNr guibg=NONE ctermbg=NONE')
vim.cmd('hi SignColumn guibg=NONE ctermbg=NONE')
vim.cmd('hi EndOfBuffer guibg=NONE ctermbg=NONE')


-- Git Fugitive Diff colors
vim.cmd('hi diffAdded ctermfg=black ctermbg=green guifg=black guibg=lightgreen')

-- LSP Floating window error colors
vim.cmd('hi DiagnosticFloatingError guifg=#c13e46 gui=bold guibg=NONE')
vim.cmd('highlight FloatBorder guibg=NONE')


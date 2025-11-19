-- ============================================================================
-- COLOR SCHEME CONFIGURATION
-- ============================================================================
-- Sets the OceanicNext color scheme and customizes specific highlight groups
-- for transparency and better visual appearance.
-- ============================================================================

-- Set the colorscheme
vim.cmd.colorscheme('OceanicNext')

-- ============================================================================
-- TRANSPARENCY SETTINGS
-- ============================================================================
-- Make background transparent for these UI elements

vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', ctermbg = 'NONE' })
vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE', ctermbg = 'NONE' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE', ctermbg = 'NONE' })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'NONE', ctermbg = 'NONE' })

-- ============================================================================
-- GIT DIFF COLORS
-- ============================================================================
-- Customize colors for git diff display (used by vim-fugitive)

vim.api.nvim_set_hl(0, 'diffAdded', {
    ctermfg = 'black',
    ctermbg = 'green',
    fg = 'black',
    bg = 'lightgreen'
})

-- ============================================================================
-- LSP DIAGNOSTIC COLORS
-- ============================================================================
-- Customize floating window colors for LSP diagnostics

vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', {
    fg = '#c13e46',
    bold = true,
    bg = 'NONE'
})

vim.api.nvim_set_hl(0, 'FloatBorder', {
    bg = 'NONE'
})

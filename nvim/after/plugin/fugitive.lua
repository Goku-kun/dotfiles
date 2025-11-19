-- ============================================================================
-- VIM-FUGITIVE - Git Integration
-- ============================================================================
-- Fugitive is a Git wrapper for Vim, providing a comprehensive Git interface.
-- Repo: https://github.com/tpope/vim-fugitive
-- ============================================================================

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
    desc = "Git status"
})

vim.keymap.set("n", "<leader>gpl", ":Git pull<CR>", {
    desc = "Git pull"
})

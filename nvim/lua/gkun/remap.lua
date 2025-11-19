-- ============================================================================
-- KEYBINDINGS - Custom Remaps
-- ============================================================================
-- Custom keymappings for improved editing workflow.
-- Leader key: <Space> (set in lazy.lua)
-- ============================================================================

-- ============================================================================
-- WINDOW NAVIGATION
-- ============================================================================

-- Jump between window splits
vim.keymap.set("n", "<C-h>", "<C-w>h", {
    noremap = true,
    desc = "Move to left window"
})

vim.keymap.set("n", "<C-l>", "<C-w>l", {
    noremap = true,
    desc = "Move to right window"
})

-- ============================================================================
-- VISUAL MODE LINE MOVEMENT
-- ============================================================================

-- Move selected lines up/down with automatic re-indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
    desc = "Move selection down"
})

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
    desc = "Move selection up"
})

-- ============================================================================
-- NORMAL MODE IMPROVEMENTS
-- ============================================================================

-- Join line below without moving cursor
vim.keymap.set("n", "J", "mzJ`z", {
    desc = "Join line below"
})

-- ============================================================================
-- SCROLLING - Keep Cursor Centered
-- ============================================================================

-- Half-page scroll with cursor in middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", {
    desc = "Scroll down (centered)"
})

vim.keymap.set("n", "<C-u>", "<C-u>zz", {
    desc = "Scroll up (centered)"
})

-- Search navigation with cursor in middle
vim.keymap.set("n", "n", "nzzzv", {
    desc = "Next search result (centered)"
})

vim.keymap.set("n", "N", "Nzzzv", {
    desc = "Previous search result (centered)"
})

-- ============================================================================
-- CLIPBOARD - Advanced Operations
-- ============================================================================

-- Paste over selection without yanking deleted text
vim.keymap.set("x", "<leader>p", [["_dP]], {
    desc = "Paste without yanking"
})

-- Delete to black hole register (don't yank)
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], {
    desc = "Delete without yanking"
})

-- ============================================================================
-- QUICKFIX AND LOCATION LIST NAVIGATION
-- ============================================================================

-- Navigate quickfix list (compilation errors, grep results, etc.)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", {
    desc = "Next quickfix item"
})

vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", {
    desc = "Previous quickfix item"
})

-- Navigate location list (buffer-local errors/references)
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", {
    desc = "Next location item"
})

vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", {
    desc = "Previous location item"
})

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {
    silent = true,
    desc = "Make file executable"
})

-- ============================================================================
-- CONFIGURATION RELOAD
-- ============================================================================

-- Source init.lua to reload configuration
vim.keymap.set("n", "<leader><CR>", function()
    print("Sourcing init.lua")
    vim.cmd("luafile ~/.config/nvim/init.lua")
end, { desc = "Reload Neovim config" })

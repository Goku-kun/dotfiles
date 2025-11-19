-- ============================================================================
-- HARPOON - Quick File Navigation
-- ============================================================================
-- Harpoon allows you to mark important files and quickly jump between them.
-- Think of it as a quick "bookmark" system for your most-used files in a project.
--
-- Repo: https://github.com/ThePrimeagen/harpoon
--
-- Usage:
-- - <leader>a: Add current file to harpoon list
-- - <C-e>: Toggle harpoon quick menu
-- - <leader>h1-4: Jump to specific harpoon marks
-- - <leader>hn/hp: Navigate to next/previous mark
-- ============================================================================

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- Add current file to harpoon marks
vim.keymap.set("n", "<leader>a", mark.add_file, {
    desc = "Harpoon: Add file to marks"
})

-- Toggle harpoon quick menu
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, {
    desc = "Harpoon: Toggle quick menu"
})

-- Navigate to specific harpoon marks (1-4)
vim.keymap.set("n", "<leader>h1", function()
    ui.nav_file(1)
end, { desc = "Harpoon: Go to file 1" })

vim.keymap.set("n", "<leader>h2", function()
    ui.nav_file(2)
end, { desc = "Harpoon: Go to file 2" })

vim.keymap.set("n", "<leader>h3", function()
    ui.nav_file(3)
end, { desc = "Harpoon: Go to file 3" })

vim.keymap.set("n", "<leader>h4", function()
    ui.nav_file(4)
end, { desc = "Harpoon: Go to file 4" })

-- Quick navigation between marked files
vim.keymap.set("n", "<leader>hn", ui.nav_next, {
    desc = "Harpoon: Next file"
})

vim.keymap.set("n", "<leader>hp", ui.nav_prev, {
    desc = "Harpoon: Previous file"
})

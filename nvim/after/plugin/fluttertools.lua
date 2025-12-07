-- ============================================================================
-- Flutter Tools Configuration
-- ============================================================================
-- This configuration sets up key mappings for Flutter development in Neovim.
-- It includes a key mapping to toggle Flutter logs using the FlutterLogToggle command.
--
-- Repo: https://github.com/nvim-flutter/flutter-tools.nvim
-- ============================================================================

vim.keymap.set("n", "<leader>fa", ":FlutterLogToggle<CR>", {
	desc = "Toggle Flutter logs",
	silent = true,
})

-- ============================================================================
-- CODECOMPANION - AI Coding Assistant
-- ============================================================================
-- CodeCompanion.nvim integrates AI assistants (Copilot, Claude, etc.) into Neovim
-- for chat, inline suggestions, and code generation.
--
-- Repo: https://github.com/olimorris/codecompanion.nvim
--
-- Available models (as of 2025):
-- - claude-sonnet-4 (recommended)
-- - claude-3.7-sonnet
-- - gpt-4.1
-- - o1-2024-12-17
-- ============================================================================

require("codecompanion").setup({
	strategies = {
		chat = {
			keymaps = {
				close = {
					modes = { n = "<Esc>", i = "<Esc>" },
					opts = {},
				},
			},
			adapter = {
				name = "copilot",
				model = "gemini-2.5-pro",
			},
		},
		inline = {
			adapter = {
				name = "copilot",
				model = "gemini-2.5-pro", -- Fixed from invalid "gpt-5"
			},
		},
		cmd = {
			adapter = {
				name = "copilot",
				model = "gemini-2.5-pro", -- Fixed from invalid "gpt-5"
			},
		},
	},
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- Open chat window
vim.keymap.set({ "n", "v" }, "<leader>cn", function()
	require("codecompanion").chat()
end, { desc = "CodeCompanion: Open chat" })

-- Toggle chat window
vim.keymap.set("n", "<leader>ca", function()
	require("codecompanion").toggle()
end, { desc = "CodeCompanion: Toggle chat" })

-- Open action palette
vim.keymap.set("n", "<leader>cc", function()
	require("codecompanion").actions()
end, { desc = "CodeCompanion: Action palette" })

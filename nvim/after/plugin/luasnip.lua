-- ============================================================================
-- LUASNIP CONFIGURATION
-- ============================================================================
-- Full-featured snippet engine setup with:
-- - Keybindings: <C-j> forward, <C-k> backward (insert mode)
-- - Choice nodes integrated with nvim-cmp
-- - Custom snippets from lua/gkun/snippets/ (Lua format)
-- - Custom snippets from snippets/ (JSON/VSCode format)
-- - friendly-snippets pre-loaded
-- ============================================================================

local ls = require("luasnip")
local types = require("luasnip.util.types")

-- ============================================================================
-- CORE CONFIGURATION
-- ============================================================================

ls.setup({
	-- Remember last snippet to jump back into it
	history = true,

	-- Update dynamic snippets as you type
	updateevents = "TextChanged,TextChangedI",

	-- Enable autosnippets (snippets that expand without trigger)
	enable_autosnippets = true,

	-- Highlight configuration for visual feedback
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "DiagnosticWarn" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "DiagnosticInfo" } },
			},
		},
	},

	-- Clean up snippets when leaving them
	region_check_events = "CursorMoved",
	delete_check_events = "TextChanged",
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- Jump forward in snippet (<C-j> in insert/select mode)
vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "LuaSnip: Expand or jump forward" })

-- Jump backward in snippet (<C-k> in insert/select mode)
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "LuaSnip: Jump backward" })

-- Cycle through choice nodes (<C-e> in insert mode)
vim.keymap.set({ "i", "s" }, "<C-e>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true, desc = "LuaSnip: Cycle choice" })

-- ============================================================================
-- SNIPPET LOADERS
-- ============================================================================

-- Load friendly-snippets (VSCode format)
require("luasnip.loaders.from_vscode").lazy_load()

-- Load custom Lua snippets from lua/gkun/snippets/
require("luasnip.loaders.from_lua").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/lua/gkun/snippets" },
})

-- Load custom JSON snippets from snippets/
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- ============================================================================
-- FILETYPE EXTENSIONS
-- ============================================================================

-- React filetypes inherit from JavaScript/TypeScript
ls.filetype_extend("javascriptreact", { "javascript", "html" })
ls.filetype_extend("typescriptreact", { "typescript", "javascript", "html" })
ls.filetype_extend("typescript", { "javascript" })

-- Flutter/Dart extensions
ls.filetype_extend("dart", { "flutter" })

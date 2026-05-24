-- ============================================================================
-- TREESITTER CONFIGURATION (Neovim 0.12+, nvim-treesitter main branch)
-- ============================================================================
-- The main branch is a full rewrite. Setup is optional; highlighting,
-- folding, and indentation are wired via FileType autocmds instead of the
-- old `require("nvim-treesitter.configs").setup({...})` modules API.
--
-- Repo: https://github.com/nvim-treesitter/nvim-treesitter (branch: main)
-- ============================================================================

local parsers = {
	-- Languages
	"c",
	"lua",
	"rust",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"go",
	"dart",
	-- Web
	"html",
	"css",
	-- Data / config
	"yaml",
	"json",
	"toml",
	-- Docs
	"markdown",
	"markdown_inline",
	"vimdoc",
	-- Shell / build
	"bash",
	"make",
	"cmake",
	"dockerfile",
	-- Vim / editor
	"vim",
	"query",
	"regex",
	-- Git
	"gitignore",
	"gitcommit",
	"git_rebase",
	"diff",
}

-- Install parsers asynchronously. No-op when already installed.
require("nvim-treesitter").install(parsers)

-- Enable treesitter highlight, fold, and indent on FileType. Skip files
-- larger than 100 KB to keep the editor responsive on huge buffers.
local ts_group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = ts_group,
	callback = function(args)
		local buf = args.buf
		local max_filesize = 100 * 1024

		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
		if ok and stats and stats.size > max_filesize then
			return
		end

		local started = pcall(vim.treesitter.start, buf)
		if not started then
			return
		end

		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- ============================================================================
-- TEXTOBJECTS (nvim-treesitter-textobjects main branch)
-- ============================================================================
-- The main branch removes the inline `keymaps` table. Configure `select`
-- behavior here, then define keymaps explicitly with `select_textobject`.

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@parameter.inner"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "<c-v>",
		},
		include_surrounding_whitespace = true,
	},
})

local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject

local textobject_mappings = {
	af = "@function.outer",
	["if"] = "@function.inner",
	ac = "@class.outer",
	ic = "@class.inner",
	ap = "@parameter.outer",
	ip = "@parameter.inner",
	as = "@statement.outer",
	is = "@statement.inner",
	ab = "@block.outer",
	ib = "@block.inner",
	al = "@loop.outer",
	il = "@loop.inner",
	aK = "@conditional.outer",
	iK = "@conditional.inner",
	ao = "@operator.outer",
	io = "@operator.inner",
	at = "@comment.outer",
	it = "@comment.inner",
	av = "@variable.outer",
	iv = "@variable.inner",
}

for lhs, capture in pairs(textobject_mappings) do
	vim.keymap.set({ "x", "o" }, lhs, function()
		select_textobject(capture, "textobjects")
	end, { desc = "Select " .. capture })
end

-- Language scope selection uses the `locals` query group.
vim.keymap.set({ "x", "o" }, "asc", function()
	select_textobject("@scope", "locals")
end, { desc = "Select language scope" })

-- ============================================================================
-- AUTO-TAG (HTML/JSX/XML closing tags)
-- ============================================================================
-- nvim-ts-autotag is a separate plugin; on the main branch it must be set
-- up directly rather than as a nested module in nvim-treesitter.configs.

require("nvim-ts-autotag").setup({})

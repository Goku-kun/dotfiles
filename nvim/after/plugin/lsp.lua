-- ============================================================================
-- LSP CONFIGURATION - Native Neovim 0.11 APIs
-- ============================================================================
-- This file configures Language Server Protocol support using Neovim's native
-- LSP client. No wrapper libraries needed - Neovim 0.11+ has everything built-in.
--
-- Key components:
-- - vim.lsp.config() - Define LSP server configurations
-- - vim.lsp.enable() - Enable LSP servers for filetypes
-- - mason.nvim - Package manager for LSP servers
-- - nvim-cmp - Completion engine
-- - null-ls - Formatting and linting
-- ============================================================================

-- ============================================================================
-- MASON SETUP - LSP Server Package Manager
-- ============================================================================

require("mason").setup({})

-- Automatically install language servers when needed
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "ts_ls", "rust_analyzer", "eslint" },
	automatic_installation = true,
})

-- ============================================================================
-- COMPLETION SETUP - nvim-cmp Configuration
-- ============================================================================

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	-- Keybindings for completion menu
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		-- Tab is reserved for Copilot
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
	}),

	-- Completion sources (order matters)
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- LSP completions
		{ name = "nvim_lua" }, -- Neovim Lua API completions
		{ name = "luasnip" }, -- Snippet completions
		{ name = "path" }, -- File path completions
	}, {
		{ name = "buffer", keyword_length = 3 }, -- Buffer completions (only after 3 chars)
	}),

	-- Completion menu appearance
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- Formatting of completion items
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				luasnip = "[Snip]",
				buffer = "[Buf]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
})

-- ============================================================================
-- LSP KEYBINDINGS - Attached to every buffer with LSP
-- ============================================================================

-- This function is called whenever an LSP attaches to a buffer
local function on_attach(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	-- Jump to definition/declaration
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
	vim.keymap.set(
		"n",
		"gi",
		vim.lsp.buf.implementation,
		vim.tbl_extend("force", opts, { desc = "Go to implementation" })
	)

	-- Hover and signature help
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

	-- Workspace and document symbols
	vim.keymap.set(
		"n",
		"<leader>ls",
		vim.lsp.buf.document_symbol,
		vim.tbl_extend("force", opts, { desc = "Document symbols" })
	)
	vim.keymap.set(
		"n",
		"<leader>lws",
		vim.lsp.buf.workspace_symbol,
		vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
	)

	-- Diagnostics
	vim.keymap.set(
		"n",
		"<leader>ld",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
	)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))

	-- Code actions and refactoring
	vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
	vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
	vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))

	-- Formatting
	vim.keymap.set("n", "<leader>fp", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format file" }))
	vim.keymap.set("n", "<space>pp", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format file" }))
end

-- ============================================================================
-- LSP SERVER CONFIGURATIONS - Native Neovim 0.11 API
-- ============================================================================

-- Get default capabilities from nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Lua Language Server (for Neovim config)
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT", -- Neovim uses LuaJIT
			},
			diagnostics = {
				globals = { "vim" }, -- Recognize 'vim' global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true), -- Neovim runtime files
				checkThirdParty = false, -- Don't ask about third-party libraries
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- TypeScript/JavaScript Language Server
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
})

-- ESLint Language Server
vim.lsp.config("eslint", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Rust Analyzer
vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy", -- Use clippy for linting
			},
		},
	},
})

-- C/C++ Language Server (clangd)
vim.lsp.config("clangd", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})

-- Markdown Language Server
vim.lsp.config("marksman", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "markdown" },
})

-- Python Language Server
vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "python" },
})

-- CSS Language Server
vim.lsp.config("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		css = {
			lint = {
				unknownAtRules = "ignore", -- Don't warn about CSS custom properties
			},
		},
	},
})

-- TOML/YAML Language Server
vim.lsp.config("taplo", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "toml" },
})

-- Docker Language Server
vim.lsp.config("dockerls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Dockerfile Language Server
vim.lsp.config("docker_compose_language_service", {
	capabilities = capabilities,
	on_attach = on_attach,
})

-- ============================================================================
-- ENABLE LSP SERVERS
-- ============================================================================
-- Neovim 0.11+ requires explicitly enabling servers after configuration

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
vim.lsp.enable("marksman")
vim.lsp.enable("pyright")
vim.lsp.enable("cssls")
vim.lsp.enable("taplo")
vim.lsp.enable("dockerls")
vim.lsp.enable("docker_compose_language_service")

-- ============================================================================
-- NULL-LS SETUP - Formatting and Linting
-- ============================================================================

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- Prettier for JavaScript/TypeScript/JSON/CSS/HTML/Markdown
		null_ls.builtins.formatting.prettier.with({
			filetypes = {
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"json",
				"css",
				"scss",
				"html",
				"markdown",
				"yaml",
			},
		}),
	},
	on_attach = function(client, bufnr)
		-- Format on Ctrl-S in insert mode
		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("i", "<C-s>", function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, { buffer = bufnr, desc = "Format file" })
		end

		-- Format visual selection
		if client.supports_method("textDocument/rangeFormatting") then
			vim.keymap.set("x", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, { buffer = bufnr, desc = "Format selection" })
		end
	end,
})

-- ============================================================================
-- PRETTIER SETUP
-- ============================================================================

require("prettier").setup({
	bin = "prettier",
	filetypes = {
		"css",
		"graphql",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"less",
		"markdown",
		"scss",
		"typescript",
		"typescriptreact",
		"yaml",
	},
})

-- ============================================================================
-- FILETYPE ASSOCIATIONS
-- ============================================================================

-- Recognize .gohtml files as HTML for LSP
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.gohtml",
	callback = function()
		vim.bo.filetype = "html"
	end,
	desc = "Treat .gohtml files as HTML",
})

-- ============================================================================
-- DIAGNOSTIC CONFIGURATION
-- ============================================================================

-- Configure diagnostic display (optional - uncomment to customize)
-- vim.diagnostic.config({
--     virtual_text = false,  -- Disable inline diagnostic messages
--     underline = true,      -- Underline diagnostics
--     signs = true,          -- Show signs in sign column
--     update_in_insert = false,  -- Don't update diagnostics while typing
-- })

-- ============================================================================
-- DIAGNOSTIC CONFIGURATION - Virtual Text (Ghost Text)
-- ============================================================================

vim.diagnostic.config({
	-- Virtual text (ghost text) configuration
	virtual_text = {
		-- Show source of diagnostic (e.g., [eslint], [lua_ls])
		source = "if_many",

		-- Prefix diagnostic with icon
		prefix = "●",

		-- Only show virtual text for errors and warnings (not hints/info)
		severity = {
			min = vim.diagnostic.severity.WARN,
		},

		-- Format the virtual text
		format = function(diagnostic)
			return string.format("%s (%s)", diagnostic.message, diagnostic.source)
		end,
	},

	-- Don't underline diagnostics
	underline = false,

	-- Configure diagnostic signs in the gutter (modern Neovim 0.11+ way)
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},

	-- Don't update diagnostics while typing (reduces noise)
	update_in_insert = false,

	-- Sort diagnostics by severity (errors first)
	severity_sort = true,

	-- Configure floating window for diagnostics
	float = {
		border = "rounded",
		source = "always", -- Always show source
		header = "",
		prefix = "",
	},
})

-- Customize diagnostic signs in the gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- If you want MORE detailed ghost text (show ALL diagnostics including hints):

-- virtual_text = {
--     source = "if_many",
--     prefix = "●",
--     -- Remove severity filter to show all diagnostics
-- },

-- If you want LESS noise (only errors, not warnings):

-- virtual_text = {
--     source = "if_many",
--     prefix = "●",
--     severity = {
--         min = vim.diagnostic.severity.ERROR,  -- Only show errors
--     },
-- },

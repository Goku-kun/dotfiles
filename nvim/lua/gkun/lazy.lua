local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	-- Telescope for fuzzy finding - lazy-loaded on command and keybindings
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		-- Track master: tag 0.1.8 (and v0.1.9) call the removed
		-- `nvim-treesitter.parsers.ft_to_lang`, which was dropped by the
		-- nvim-treesitter main-branch rewrite. Master replaced that call
		-- with `vim.treesitter.language.get_lang` + `add` + `start`.
		branch = "master",
		keys = {
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fg", desc = "Live grep" },
			{ "<leader>fb", desc = "Find buffers" },
			{ "<leader>fh", desc = "Find help" },
			{ "<leader>fd", desc = "Find diagnostics" },
			{ "<leader>gcp", desc = "Git commit picker" },
			{ "<leader>gbp", desc = "Git branch picker" },
			{ "<leader>gsp", desc = "Git stash picker" },
			{ "<leader>:", desc = "Command history" },
			{ "<leader>km", desc = "Keymaps" },
			{ "<leader>/", desc = "Fuzzy find buffer" },
			{ "<leader>ed", desc = "Edit dotfiles" },
			{ "<leader>cdcd", desc = "CD to codedex" },
			{ "<C-p>", desc = "Git files" },
		},
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	},

	-- OceanicNext Theme installation (config in colors.lua)
	{ "mhartington/oceanic-next" },

	-- Autocomplete brackets/quotes and other help in insert mode
	{ "raimondi/delimitmate" },

	-- Indentation guide
	-- { 'nathanaelkane/vim-indent-guides' },

	-- Devicons for files
	{ "nvim-tree/nvim-web-devicons" },

	-- rainbow parentheses
	{ "junegunn/rainbow_parentheses.vim" },

	-- Plugin for changing surrounding brackets
	{ "tpope/vim-surround" },

	-- Edge colorscheme
	{ "sainnhe/edge" },

	-- vim-airline for cool statusbar line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "oceanicnext",
				section_separators = "",
				component_separators = "",
				globalstatus = true, -- Single statusline at bottom
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				-- show me the full file path
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "fugitive", "nerdtree" },
		},
	},

	-- Markdown Previewer
	-- use('iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']})

	-- Neo-tree - Modern file explorer alternative to NERDTree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
	},

	-- used with neo-tree
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			-- dashboard = { enabled = true },
			-- explorer = { enabled = true },
			indent = { enabled = true },
			-- input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			-- quickfile = { enabled = true },
			scope = { enabled = true },
			-- scroll = { enabled = true },
			-- statuscolumn = { enabled = true },
			-- words = { enabled = true },

			---@class snacks.image.Config
			---@field enabled? boolean enable image viewer
			---@field wo? vim.wo|{} options for windows showing the image
			---@field bo? vim.bo|{} options for the image buffer
			---@field formats? string[]
			--- Resolves a reference to an image with src in a file (currently markdown only).
			--- Return the absolute path or url to the image.
			--- When `nil`, the path is resolved relative to the file.
			---@field resolve? fun(file: string, src: string): string?
			---@field convert? snacks.image.convert.Config
			image = {
				enabled = false,
				formats = {
					"png",
					"jpg",
					"jpeg",
					"gif",
					"bmp",
					"webp",
					"tiff",
					"heic",
					"avif",
					"mp4",
					"mov",
					"avi",
					"mkv",
					"webm",
					"pdf",
					"icns",
				},
				force = false, -- try displaying the image, even if the terminal does not support it
				doc = {
					-- enable image viewer for documents
					-- a treesitter parser must be available for the enabled languages.
					enabled = true,
					-- render the image inline in the buffer
					-- if your env doesn't support unicode placeholders, this will be disabled
					-- takes precedence over `opts.float` on supported terminals
					inline = true,
					-- render the image in a floating window
					-- only used if `opts.inline` is disabled
					float = true,
					max_width = 80,
					max_height = 40,
					-- Set to `true`, to conceal the image text when rendering inline.
					-- (experimental)
					---@param lang string tree-sitter language
					---@param type snacks.image.Type image type
					conceal = function(lang, type)
						-- only conceal math expressions
						return type == "math"
					end,
				},
				img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
				-- window options applied to windows displaying image buffers
				-- an image buffer is a buffer with `filetype=image`
				wo = {
					wrap = false,
					number = false,
					relativenumber = false,
					cursorcolumn = false,
					signcolumn = "no",
					foldcolumn = "0",
					list = false,
					spell = false,
					statuscolumn = "",
				},
				cache = vim.fn.stdpath("cache") .. "/snacks/image",
				debug = {
					request = false,
					convert = false,
					placement = false,
				},
				env = {},
				-- icons used to show where an inline image is located that is
				-- rendered below the text.
				icons = {
					math = "󰪚 ",
					chart = "󰄧 ",
					image = " ",
				},
				---@class snacks.image.convert.Config
				convert = {
					notify = false, -- show a notification on error
					---@type snacks.image.args
					mermaid = function()
						local theme = vim.o.background == "light" and "neutral" or "dark"
						return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
					end,
					---@type table<string,snacks.image.args>
					magick = {
						default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
						vector = { "-density", 192, "{src}[{page}]" }, -- used by vector images like svg
						math = { "-density", 192, "{src}[{page}]", "-trim" },
						pdf = { "-density", 192, "{src}[{page}]", "-background", "white", "-alpha", "remove", "-trim" },
					},
				},
				math = {
					enabled = true, -- enable math expression rendering
					-- in the templates below, `${header}` comes from any section in your document,
					-- between a start/end header comment. Comment syntax is language-specific.
					-- * start comment: `// snacks: header start`
					-- * end comment:   `// snacks: header end`
					typst = {
						tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
					},
					latex = {
						font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
						-- for latex documents, the doc packages are included automatically,
						-- but you can add more packages here. Useful for markdown documents.
						packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
						tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
					},
				},
			},
		},
	},

	-- Bufferline - Show open buffers as tabs at the top
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
	},

	-- UNDO tree
	{ "mbbill/undotree" },

	-- VIM FUGITIVE!
	{ "tpope/vim-fugitive" },
	-- Need the Git gutter for moving through hunks of all changes
	{ "airblade/vim-gitgutter" },

	-- Git worktree management plugin
	{
		"polarmutex/git-worktree.nvim",
		version = "^2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- cool animation plugin
	{ "Eandrju/cellular-automaton.nvim" },

	-- Practice vim game
	{ "ThePrimeagen/vim-be-good" },

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xqf",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	-- Treesitter (main-branch rewrite). Requires Neovim 0.12+. Config and
	-- highlight wiring live in after/plugin/treesitter.lua.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true, -- Use number of context line. Should it always be shown?
				zindex = 20, -- The Z-index of the context window. It controls on which side of the code the context should appear.
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				multiline_threshold = 1, -- When there are multiple lines in the context, this is the threshold for how many lines should be shown.
			})
		end,
	},
	-- Used to select/swap/yank text objects in treesitter; see treesitter.lua for more
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			vim.g.no_plugin_maps = true
		end,
	},

	-- Highlight references to the symbol under the cursor (replaces
	-- nvim-treesitter-refactor's highlight_definitions, which is unmaintained
	-- and broken on current Neovim).
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("illuminate").configure({
				providers = { "lsp", "treesitter", "regex" },
				delay = 100,
				under_cursor = true,
			})
			vim.keymap.set("n", "<a-*>", function()
				require("illuminate").goto_next_reference(false)
			end, { desc = "Next reference (illuminate)" })
			vim.keymap.set("n", "<a-#>", function()
				require("illuminate").goto_prev_reference(false)
			end, { desc = "Prev reference (illuminate)" })
		end,
	},
	-- Used to autocomplete tags in HTML, JSX, XML, etc.
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- nvim-treesitter/playground was removed: Neovim 0.10+ ships `:InspectTree`
	-- and `:Inspect` natively, and the plugin uses the old modules API which is
	-- incompatible with the main-branch rewrite.
	{ "theprimeagen/harpoon" },

	-- Indentation guide for treesitter
	{ "lukas-reineke/indent-blankline.nvim" },
	-- { "https://codeberg.org/esensar/nvim-dev-container" },

	-- smear cursor
	-- {
	--     "sphamba/smear-cursor.nvim",
	--     opts = {
	--         -- Smear cursor when switching buffers or windows.
	--         smear_between_buffers = true,
	--
	--         -- Smear cursor when moving within line or to neighbor lines.
	--         -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
	--         smear_between_neighbor_lines = true,
	--
	--         -- Draw the smear in buffer space instead of screen space when scrolling
	--         scroll_buffer_space = true,
	--
	--         -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
	--         -- Smears will blend better on all backgrounds.
	--         legacy_computing_symbols_support = false,
	--
	--         -- Smear cursor in insert mode.
	--         -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
	--         smear_insert_mode = true,
	--     },
	-- },

	{ url = "https://codeberg.org/andyg/leap.nvim" },

	-- LSP support
	-- LSP: Mason for package management
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},

	-- LSP: Bridge between Mason and lspconfig.
	-- Setup is performed once in after/plugin/lsp.lua. Do NOT use `opts` here —
	-- Lazy auto-calls setup with `opts`, which would fire before lsp.lua and
	-- auto-enable every installed Mason server (emmet, graphql, biome, astro...).
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
	},

	-- LSP: Neovim LSP configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	},

	-- Completion engine (blink.cmp - replaces nvim-cmp on Neovim 0.12+)
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "L3MON4D3/LuaSnip" },
		version = "1.*",
		event = "InsertEnter",
		opts = {
			keymap = { preset = "default" },
			snippets = { preset = "luasnip" },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 300 },
			},
		},
		opts_extend = { "sources.default" },
	},

	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		lazy = true,
		build = "make install_jsregexp",
	},
	{ "rafamadriz/friendly-snippets", lazy = true },

	-- Formatting: none-ls and prettier
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"MunifTanjim/prettier.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvimtools/none-ls.nvim" },
	},

	-- Flutter and Dart support
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
			"mfussenegger/nvim-dap",
		},
		config = true,
		debugger = {
			enabled = true,
			register_configurations = function(_)
				-- require("dap").configurations.dart = {}
				-- require("dap.ext.vscode").load_launchjs()
			end,
		},
	},

	-- Flutter Bloc support
	{
		"wa11breaker/flutter-bloc.nvim",
		dependencies = {
			"nvimtools/none-ls.nvim", -- Required for code actions
		},
		opts = {
			bloc_type = "default", -- Choose from: 'default', 'equatable', 'freezed'
			use_sealed_classes = false,
			enable_code_actions = true,
		},
	},

	-- {
	-- 	"github/copilot.vim",
	-- 	event = "InsertEnter",
	-- },

	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
			{ "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
		},
		opts = {},
	},

	{ "JoosepAlviste/nvim-ts-context-commentstring" },

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},

	{ "HakonHarnes/img-clip.nvim" },
	{ "brenoprata10/nvim-highlight-colors" },

	checker = { enabled = true },
})

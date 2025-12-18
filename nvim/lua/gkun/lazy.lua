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
		tag = "0.1.8",
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

	-- Treesitter for advanced syntax highlighting - lazy-loaded on file open
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
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
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Treesitter refactor
	{
		"nvim-treesitter/nvim-treesitter-refactor",
		after = "nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- Used to autocomplete tags in HTML, JSX, XML, etc.
	{
		"windwp/nvim-ts-autotag",
		after = "nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{ "nvim-treesitter/playground" },
	{ "theprimeagen/harpoon" },

	-- Indentation guide for treesitter
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "https://codeberg.org/esensar/nvim-dev-container" },

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

	{ "ggandor/leap.nvim" },

	-- LSP support
	-- LSP: Mason for package management
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},

	-- LSP: Bridge between Mason and lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = { "lua_ls", "ts_ls", "rust_analyzer", "eslint" },
			automatic_installation = true,
		},
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

	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},

	-- Individual completion sources
	{ "hrsh7th/cmp-nvim-lsp", lazy = true },
	{ "hrsh7th/cmp-buffer", lazy = true },
	{ "hrsh7th/cmp-path", lazy = true },
	{ "hrsh7th/cmp-nvim-lua", lazy = true },

	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
        version="v2.*",
		lazy = true,
		build = "make install_jsregexp",
	},
	{ "saadparwaiz1/cmp_luasnip", lazy = true },
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

	{
		"github/copilot.vim",
		event = "InsertEnter",
	},

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
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
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

	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			filetypes = {
				codecompanion = {
					prompt_for_file_name = false,
					template = "[Image]($FILE_PATH)",
					use_absolute_path = true,
				},
			},
		},
	},
	{ "brenoprata10/nvim-highlight-colors" },

	checker = { enabled = true },
})

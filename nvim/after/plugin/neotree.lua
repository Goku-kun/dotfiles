-- ============================================================================
-- NEO-TREE - Modern File Explorer Configuration
-- ============================================================================
-- Neo-tree is a modern file explorer that replaces netrw and provides an
-- alternative to NERDTree with better performance and more features.
--
-- Repo: https://github.com/nvim-neo-tree/neo-tree.nvim
--
-- Features:
-- - Git integration with status indicators
-- - LSP diagnostics in file tree
-- - Automatic directory opening when running `nvim .`
-- - Hidden files visible by default
-- - Follow current file automatically
-- ============================================================================

-- ============================================================================
-- AUTO-OPEN ON DIRECTORY
-- ============================================================================
-- Automatically open neo-tree when opening a directory (e.g., `nvim .`)

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function(data)
-- 		-- Check if the argument is a directory
-- 		local directory = vim.fn.isdirectory(data.file) == 1
--
-- 		if directory then
-- 			-- Change to the directory
-- 			vim.cmd.cd(data.file)
--
-- 			-- Open neo-tree
-- 			require("neo-tree.command").execute({ action = "show" })
-- 		end
-- 	end,
-- 	desc = "Open neo-tree when opening a directory",
-- })

-- ============================================================================
-- NEO-TREE SETUP
-- ============================================================================

require("neo-tree").setup({
	close_if_last_window = false, -- Don't close neo-tree if it's the last window
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,

	-- ========================================================================
	-- DEFAULT COMPONENT CONFIGS
	-- ========================================================================
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		indent = {
			indent_size = 2,
			padding = 1,
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			with_expanders = nil,
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "󰜌",
			default = "*",
			highlight = "NeoTreeFileIcon",
		},
		modified = {
			symbol = "[+]",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = false,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbols = {
				added = "✚",
				modified = "",
				deleted = "✖",
				renamed = "󰁕",
				untracked = "",
				ignored = "",
				unstaged = "󰄱",
				staged = "",
				conflict = "",
			},
		},
	},

	-- ========================================================================
	-- WINDOW CONFIGURATION
	-- ========================================================================
	window = {
		position = "left",
		width = 35,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			["<space>"] = "none", -- Disable space (conflicts with leader key)
			["<cr>"] = "open",
			["<esc>"] = "cancel",
			["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
			["l"] = "open",
			["h"] = "close_node",
			["z"] = "close_all_nodes",
			["Z"] = "expand_all_nodes",
			["a"] = {
				"add",
				config = {
					show_path = "relative",
				},
			},
			["A"] = "add_directory",
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = "copy",
			["m"] = "move",
			["q"] = "close_window",
			["R"] = "refresh",
			["?"] = "show_help",
			["<"] = "prev_source",
			[">"] = "next_source",
			["i"] = "show_file_details",
			["H"] = "toggle_hidden", -- Toggle hidden files visibility
		},
	},

	-- ========================================================================
	-- FILESYSTEM CONFIGURATION
	-- ========================================================================
	filesystem = {
		-- Follow current file
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},

		-- Take over netrw behavior
		hijack_netrw_behavior = "open_current",

		-- Auto-refresh on file changes
		use_libuv_file_watcher = true,

		-- Hidden files configuration
		filtered_items = {
			visible = true, -- Show hidden files by default
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_hidden = false, -- Only works on Windows for hidden file attribute
			hide_by_name = {
				-- Add any files/folders you want to hide
				-- "node_modules",
			},
			hide_by_pattern = {
				-- Uses glob pattern
				-- "*.meta",
			},
			always_show = {
				-- Remain visible even if other settings would hide them
				-- ".gitignored",
			},
			never_show = {
				".DS_Store",
				"thumbs.db",
				".git",
			},
			never_show_by_pattern = {
				-- Uses glob pattern
				-- ".null-ls_*",
			},
		},

		-- Window settings
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["H"] = "toggle_hidden",
				["/"] = "fuzzy_finder",
				["D"] = "fuzzy_finder_directory",
				["#"] = "fuzzy_sorter",
				["f"] = "filter_on_submit",
				["<c-x>"] = "clear_filter",
				["[g"] = "prev_git_modified",
				["]g"] = "next_git_modified",
			},
		},
	},

	-- ========================================================================
	-- BUFFERS CONFIGURATION
	-- ========================================================================
	buffers = {
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		group_empty_dirs = true,
		show_unloaded = true,
		window = {
			mappings = {
				["bd"] = "buffer_delete",
				["<bs>"] = "navigate_up",
				["."] = "set_root",
			},
		},
	},

	-- ========================================================================
	-- GIT STATUS CONFIGURATION
	-- ========================================================================
	git_status = {
		window = {
			position = "float",
			mappings = {
				["A"] = "git_add_all",
				["gu"] = "git_unstage_file",
				["ga"] = "git_add_file",
				["gr"] = "git_revert_file",
				["gc"] = "git_commit",
				["gp"] = "git_push",
				["gg"] = "git_commit_and_push",
			},
		},
	},
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

vim.keymap.set("n", "<leader>nt", "<cmd>Neotree toggle<cr>", {
	desc = "Neo-tree: Toggle",
})

vim.keymap.set("n", "<leader>nf", "<cmd>Neotree focus<cr>", {
	desc = "Neo-tree: Focus",
})

vim.keymap.set("n", "<leader>ng", "<cmd>Neotree float git_status<cr>", {
	desc = "Neo-tree: Git status",
})

vim.keymap.set("n", "<leader>nb", "<cmd>Neotree toggle show buffers right<cr>", {
	desc = "Neo-tree: Show buffers",
})

-- ============================================================================
-- BUFFERLINE - Buffer Tabs Configuration
-- ============================================================================
-- Bufferline shows open buffers as tabs at the top of the editor.
-- Provides visual buffer management with mouse support, diagnostics, and more.
--
-- Repo: https://github.com/akinsho/bufferline.nvim
-- ============================================================================

require("bufferline").setup({
	options = {
		mode = "buffers", -- Show buffers instead of tabs

		-- Style and appearance
		themable = true, -- Allow theme colors

		-- Numbers: show buffer numbers for quick jumping
		numbers = function(opts)
			return string.format("%s", opts.ordinal)
		end,

		-- Close icons
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		left_mouse_command = "buffer %d",
		middle_mouse_command = nil,

		-- Icons
		buffer_close_icon = "󰅖",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",

		-- Name length limits
		max_name_length = 18,
		max_prefix_length = 15,
		truncate_names = true,
		tab_size = 20,

		-- Diagnostics integration
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,

		-- Filter buffers
		custom_filter = function(buf_number, buf_numbers)
			-- Don't show [No Name] buffers
			if vim.fn.bufname(buf_number) == "" then
				return false
			end
			-- Don't show quickfix buffers
			if vim.bo[buf_number].filetype == "qf" then
				return false
			end
			return true
		end,

		-- File tree offset
		offsets = {
			{
				filetype = "NERDTree",
				text = "File Explorer",
				text_align = "center",
				separator = true,
				highlight = "Directory",
			},
			{
				filetype = "neo-tree",
				raw = " %{%v:lua.__get_selector()%} ",
				highlight = { sep = { link = "WinSeparator" } },
				separator = "┃",
			},
		},

		-- Display settings
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		show_duplicate_prefix = true,
		separator_style = "thin",
		enforce_regular_tabs = false,
		always_show_bufferline = true,

		-- Hover behavior
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},

		-- Sorting
		sort_by = "insert_after_current",

		-- Groups and pinning
		groups = {
			options = {
				toggle_hidden_on_enter = true,
			},
			items = {
				require("bufferline.groups").builtin.pinned:with({ icon = "" }),
			},
		},
	},

	-- Highlights for better visibility
	highlights = {
		buffer_selected = {
			bold = true,
			italic = false,
		},
		numbers_selected = {
			bold = true,
			italic = false,
		},
		modified_selected = {
			bold = true,
		},
		error_selected = {
			bold = true,
		},
		warning_selected = {
			bold = true,
		},
	},
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- Navigate between buffers
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", {
	desc = "Bufferline: Next buffer",
})
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", {
	desc = "Bufferline: Previous buffer",
})
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", {
	desc = "Bufferline: Previous buffer",
})
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", {
	desc = "Bufferline: Next buffer",
})

-- Buffer management
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<cr>", {
	desc = "Bufferline: Pick buffer",
})
vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineTogglePin<cr>", {
	desc = "Bufferline: Pin/unpin buffer",
})
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", {
	desc = "Bufferline: Delete buffer",
})
vim.keymap.set("n", "<leader>bD", "<cmd>BufferLinePickClose<cr>", {
	desc = "Bufferline: Pick buffer to close",
})

-- Close multiple buffers
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", {
	desc = "Bufferline: Close other buffers",
})
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", {
	desc = "Bufferline: Close buffers to right",
})
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", {
	desc = "Bufferline: Close buffers to left",
})

-- Jump to buffer by number (1-9)
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		require("bufferline").go_to(i, true)
	end, {
		desc = "Bufferline: Go to buffer " .. i,
	})
end


-- ============================================================================
-- NEOVIM CORE SETTINGS
-- ============================================================================
-- General editor configuration, appearance, and behavior settings.
-- Leader key is set in lazy.lua before plugins load.
-- ============================================================================

-- ============================================================================
-- SCROLLING AND VIEWPORT
-- ============================================================================

vim.opt.scrolloff = 15  -- Keep 15 lines visible above/below cursor
vim.opt.sidescroll = 15 -- Horizontal scroll increment

-- ============================================================================
-- LINE NUMBERS
-- ============================================================================

vim.opt.nu = true             -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers for easy jumping

-- ============================================================================
-- LINE WRAPPING AND ENCODING
-- ============================================================================

vim.opt.wrap = false       -- Disable line wrapping
vim.opt.encoding = "utf-8" -- Use UTF-8 encoding

-- ============================================================================
-- INDENTATION
-- ============================================================================

vim.opt.tabstop = 4        -- Tab width is 4 spaces
vim.opt.softtabstop = 4    -- Backspace deletes 4 spaces
vim.opt.shiftwidth = 4     -- Indent width is 4 spaces
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart auto-indenting

-- ============================================================================
-- CLIPBOARD
-- ============================================================================

vim.opt.clipboard = "unnamedplus" -- Use system clipboard for all operations

-- ============================================================================
-- YANK HIGHLIGHTING
-- ============================================================================

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
    desc = "Briefly highlight yanked text",
})

-- ============================================================================
-- BACKUP AND UNDO
-- ============================================================================

vim.opt.swapfile = false                               -- Disable swap files
vim.opt.backup = false                                 -- Disable backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Undo file location
vim.opt.undofile = true                                -- Enable persistent undo

-- ============================================================================
-- WHITESPACE VISUALIZATION
-- ============================================================================

vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = " " }

-- ============================================================================
-- WORD BOUNDARIES
-- ============================================================================

vim.opt.iskeyword:append("-") -- Treat hyphenated words as one word
vim.opt.iskeyword:remove("_") -- Treat underscore as word separator

-- ============================================================================
-- SEARCH
-- ============================================================================

vim.opt.hlsearch = false -- Don't highlight search results
vim.opt.incsearch = true -- Incremental search (search as you type)

-- ============================================================================
-- APPEARANCE
-- ============================================================================

vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
vim.opt.signcolumn = "yes"    -- Always show sign column (for git, diagnostics)
vim.opt.isfname:append("@-@") -- Allow @ in filenames

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

vim.opt.updatetime = 200   -- Faster completion (default 4000ms)
vim.o.timeout = true       -- Enable timeout for key sequences
vim.o.timeoutlen = 300     -- Time to wait for key sequence (ms)
vim.opt.lazyredraw = true  -- Only redraw when needed
vim.opt.redrawtime = 10000 -- Allow more time for redraws

-- ============================================================================
-- FOLDING
-- ============================================================================
-- Treesitter-based code folding for functions, classes, blocks, etc.
-- Works with any language that has a treesitter parser installed.
--
-- Keybindings (built-in vim):
--   za    Toggle fold under cursor
--   zc    Close fold under cursor
--   zo    Open fold under cursor
--   zM    Close all folds in file
--   zR    Open all folds in file
--   zj/zk Jump to next/previous fold
--
-- Note: LSP folding (vim.lsp.foldexpr) was tested but has timing issues
-- with some servers like dartls. Treesitter folding is more reliable.
-- ============================================================================

vim.opt.foldmethod = "expr"                          -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Treesitter-based folding
vim.opt.foldlevelstart = 99                          -- Open all folds by default
vim.opt.foldlevel = 99                               -- Keep folds open
vim.opt.foldenable = true                            -- Enable folding

-- ============================================================================
-- STATUSCOLUMN
-- ============================================================================
-- Minimal statuscolumn with dim fold indicators.
-- Layout: [signs] [line number] [fold icon] [space]
--
-- Fold icons:
--   ›  Fold is open (can be closed with zc)
--   ‹  Fold is closed (can be opened with zo)
--
-- Customization:
--   - Change "Comment" to "NonText" for even dimmer icons
--   - Change › and ‹ to other characters (e.g., ▸/▾ or ●/○)
-- ============================================================================

-- Dim fold indicator highlight (theme-adaptive, links to Comment)
vim.api.nvim_set_hl(0, "FoldIndicator", { link = "Comment" })

-- Statuscolumn function: signs + line number + subtle fold chevron
_G.StatusColumn = function()
	local lnum = vim.v.lnum

	-- Fold indicator (dim chevron)
	local fold = " "
	if vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
		if vim.fn.foldclosed(lnum) == -1 then
			fold = "%#FoldIndicator#›%*" -- open fold
		else
			fold = "%#FoldIndicator#‹%*" -- closed fold
		end
	end

	return "%s%l " .. fold .. " "
end

vim.opt.statuscolumn = "%!v:lua.StatusColumn()"

-- ============================================================================
-- PYTHON PROVIDERS
-- ============================================================================

vim.g.python_host_prog = "/usr/bin/python"
vim.g.python3_host_prog = "/usr/bin/python3"

-- ============================================================================
-- LANGUAGE-SPECIFIC SETTINGS
-- ============================================================================

-- Rust: auto-format on save with rustfmt
vim.g.rustfmt_autosave = 1

-- ============================================================================
-- NERDTREE CONFIGURATION
-- ============================================================================

vim.g.NERDTreeDirArrowExpandable = "▶"
vim.g.NERDTreeDirArrowCollapsible = "🔽"
vim.g.NERDTreeShowHidden = 1

-- ============================================================================
-- CUSTOM COMMANDS
-- ============================================================================

-- Copy full file path to clipboard
vim.api.nvim_create_user_command("Cppath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("Path copied to clipboard: " .. path)
end, { desc = "Copy full file path to clipboard" })

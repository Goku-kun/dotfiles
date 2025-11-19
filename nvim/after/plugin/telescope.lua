-- ============================================================================
-- TELESCOPE - Fuzzy Finder
-- ============================================================================
-- Telescope is a highly extendable fuzzy finder over lists.
-- Used for finding files, live grep, git integration, and more.
--
-- Repo: https://github.com/nvim-telescope/telescope.nvim
-- ============================================================================

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {
    defaults = {
        file_ignore_patterns = { "node_modules", ".git", "^public/repl*" },
        mappings = {
            i = {
                ["<C-e>"] = require("telescope.actions").send_selected_to_qflist,
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
            }
        }
    }
}

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [f]iles' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'find git files' })
--vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
--vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, { desc = '[f]ile [g]rep' })

-- find active buffers
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = '[f]ind [b]uffers' })

-- find help tags
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = '[f]ind [h]elp' })

-- find diagnostics
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = '[f]ind [d]iagnostics' })

-- git commits picker
vim.keymap.set("n", "<leader>gcp", builtin.git_commits, { desc = '[g]it [c]ommit [p]icker' })

-- git branches picker
vim.keymap.set("n", "<leader>gbp", builtin.git_branches, { desc = '[g]it [b]ranch [p]icker' })

-- git stash picker
vim.keymap.set("n", "<leader>gsp", builtin.git_stash, { desc = '[g]it [s]tash [p]icker' })

vim.keymap.set("n", "<leader>:", builtin.commands, { desc = 'list [c]ommands' })

vim.keymap.set("n", "<leader>km", builtin.keymaps, { desc = 'list [k]ey[m]aps' })

vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = '[/] fuzzy find in current buffer' })


-- configure nvim dotfiles from anywhere
vim.keymap.set("n", "<leader>ed", function()
    builtin.find_files({ cwd = "~/.config/nvim", prompt = "nvim config files" })
end, { desc = '[e]dit [d]otfiles' })

vim.keymap.set("n", "<leader>cdcd", function()
    builtin.find_files({ cwd = "~/programming/work/codedex/", prompt = "codedex quick search files" })
end, { desc = 'cd to codedex' })


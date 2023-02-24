local telescope = require('telescope')
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
--vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
--vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args)
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- git commits picker
vim.keymap.set("n", "<leader>gcp", builtin.git_commits)

-- configure nvim dotfiles from anywhere
vim.keymap.set("n", "<leader>ed", function()
    builtin.find_files({ cwd = "~/.config/nvim", prompt = "nvim config files" })
end)

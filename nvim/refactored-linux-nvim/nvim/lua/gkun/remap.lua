vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)

-- remap for sourcing the init.vim file
vim.keymap.set("n", "<leader><CR>", "<cmd>so ~/.config/nvim/init.vim")

-- remap for jumping across open splits
vim.keymap.set("n", "<C-h>", "<C-w>h", {noremap = true})
vim.keymap.set("n", "<C-l>", "<C-w>l", {noremap = true})

-- remap for moving the selected lines with support for block indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

-- remap for scrolling the page while keeping the cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- remap for keeping the search jumps in the center of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

---- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

---- next greatest remap ever : asbjornHaland
--vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
--vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

--vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>fp", vim.lsp.buf.format)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

--vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- remap for making a file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>cp", "<cmd>let @+ = expand('%:p')<CR>", { silent = true })


-- source the init.lua file
--vim.keymap.set("n", "<leader><CR>", "<cmd>so ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader><CR>", function()
  print("sourcing init.lua")
  vim.cmd("luafile ~/.config/nvim/init.lua")
end)

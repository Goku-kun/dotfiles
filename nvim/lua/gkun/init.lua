-- Set leader key FIRST, before any keymaps are defined
-- <Leader> is replaced by mapleader value at mapping definition time
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("gkun.set")
require("gkun.remap")
require("gkun.lazy")

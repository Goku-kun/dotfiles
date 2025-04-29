local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
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
    -- Telescope for fuzzy finding
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim" },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    },

    -- OceanicNext Theme installation (config in colors.lua)
    { 'mhartington/oceanic-next' },

    -- Autocomplete brackets/quotes and other help in insert mode
    { 'raimondi/delimitmate' },

    -- Indentation guide
    { 'nathanaelkane/vim-indent-guides' },

    -- Nerd commentor for comments
    --{ 'preservim/nerdcommenter' },

    -- Devicons for files
    { 'nvim-tree/nvim-web-devicons' },

    -- rainbow parentheses
    { 'junegunn/rainbow_parentheses.vim' },

    -- Plugin for changing surrounding brackets
    { 'tpope/vim-surround' },

    -- Edge colorscheme
    { 'sainnhe/edge' },

    -- vim-airline for cool statusbar line
    { 'vim-airline/vim-airline' },
    { 'vim-airline/vim-airline-themes' },

    -- Markdown Previewer
    -- use('iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']})

    -- Nerd Tree
    { 'preservim/nerdtree' },

    -- UNDO tree
    { 'mbbill/undotree' },

    -- VIM FUGITIVE!
    { 'tpope/vim-fugitive' },
    -- Need the Git gutter for moving through hunks of all changes
    { 'airblade/vim-gitgutter' },

    -- cool animation plugin
    { 'Eandrju/cellular-automaton.nvim' },

    -- Practice vim game
    { 'ThePrimeagen/vim-be-good' },

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

    -- Treesitter for language parsing
    { 'nvim-treesitter/nvim-treesitter' },
    -- Used to select/swap/yank text objects in treesitter; see treesitter.lua for more
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- how to load after a plugin in lazy.nvim
        after = "nvim-treesitter",
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
    { 'nvim-treesitter/playground' },
    { 'theprimeagen/harpoon' },

    -- Indentation guide for treesitter
    { "lukas-reineke/indent-blankline.nvim" },


    -- LSP support
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'williamboman/nvim-lsp-installer' },
            { 'neovim/nvim-lspconfig' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },


            -- prettier for JS,TS
            { 'nvimtools/none-ls.nvim' },
            { 'MunifTanjim/prettier.nvim' }
        },

        --use ('jiangmiao/auto-pairs');
    },

    { 'github/copilot.vim' },

    {
        "numToStr/Comment.nvim",
        lazy = false,
    },

    {'JoosepAlviste/nvim-ts-context-commentstring'},
})

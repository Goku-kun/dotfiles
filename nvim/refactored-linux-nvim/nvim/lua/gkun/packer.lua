vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

  -- Packer package manager
  use 'wbthomason/packer.nvim'

  -- Telescope for fuzzy finding
  use( {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim', "nvim-telescope/telescope-live-grep-args.nvim"} },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  })

  -- OceanicNext Theme installation (config in colors.lua)
  use ('mhartington/oceanic-next')

  -- Autocomplete brackets/quotes and other help in insert mode
  use ('raimondi/delimitmate')

  -- Indentation guide
  use ('nathanaelkane/vim-indent-guides')

  -- Nerd commentor for comments
  use('preservim/nerdcommenter')

  -- Devicons for files
  use 'nvim-tree/nvim-web-devicons'

  -- rainbow parentheses
  --use('junegunn/rainbow_parentheses.vim')

  -- Plugin for changing surrounding brackets
  use('tpope/vim-surround')

  -- Edge colorscheme
  use('sainnhe/edge')

  -- vim-airline for cool statusbar line
  use('vim-airline/vim-airline')
  use('vim-airline/vim-airline-themes')

  -- Markdown Previewer
  -- use('iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']})

  -- Nerd Tree
  use('preservim/nerdtree')

  -- UNDO tree
  use('mbbill/undotree')

  -- VIM FUGITIVE!
  use('tpope/vim-fugitive')
  -- Need the Git gutter for moving through hunks of all changes
  use('airblade/vim-gitgutter')

  -- TODO
  use('sheerun/vim-polyglot')

  -- cool animation plugin
  use('Eandrju/cellular-automaton.nvim')

  -- Practice vim game
  use('ThePrimeagen/vim-be-good')

  -- Treesitter for language parsing
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')


  -- Markdown Preview
  --use({'iamcco/markdown-preview.nvim',
    --run = function() vim.fn["mkdp#util#install"]() end
  --})



  -- LSP support
  use {
  'VonHeikemen/lsp-zero.nvim',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'saadparwaiz1/cmp_luasnip'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lua'},

    -- Snippets
    {'L3MON4D3/LuaSnip'},
    {'rafamadriz/friendly-snippets'},


    -- prettier for JS,TS
    {'jose-elias-alvarez/null-ls.nvim'},
    {'MunifTanjim/prettier.nvim'}
  };

  use('github/copilot.vim')
  --use ('jiangmiao/auto-pairs');
}
end)

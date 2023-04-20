local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
})


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'cmp_tabnine' },
        { name = 'cmp_path' },
        { name = 'cmp_buffer' },
    }
})

lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    underline = false,
})


local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.document_symbol() end, opts)
    vim.keymap.set("n", "<leader>lws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>lca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>lrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<space>pp", function() vim.lsp.buf.format() end, opts)
end

lsp.on_attach(on_attach)

require 'lspconfig'.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
    on_attach = on_attach
}


require "lspconfig".tsserver.setup {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    on_attach = on_attach,
}

require "lspconfig".clangd.setup {
    on_attach = on_attach,
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    single_file_support = true,
}

vim.keymap.set("i", "<C-s>", vim.cmd.Prettier)

--[[prettier specific section]]
--[[local null_ls = require("null-ls")]]
--[[null_ls.setup({]]
--[[on_attach = function(client, bufnr)]]
--[[if client.supports_method("textDocument/formatting") then]]
--[[vim.keymap.set("n", "<leader>fp", function()]]
--[[vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })]]
--[[end, { buffer = bufnr, desc = "[lsp] format" })]]
--[[end]]
--[[if client.supports_method("textDocument/rangeFormatting") then]]
--[[vim.keymap.set("x", "<leader>fp", function()]]
--[[vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })]]
--[[end, { buffer = bufnr, desc = "[lsp] format" })]]
--[[end]]
--[[end]]
--[[})]]
--[[local prettier = require("prettier")]]
--[[prettier.setup({]]
--[[bin = 'prettier',]]
--[[filetypes = {]]
--[["css",]]
--[["graphql",]]
--[["html",]]
--[["javascript",]]
--[["javascriptreact",]]
--[["json",]]
--[["less",]]
--[["markdown",]]
--[["scss",]]
--[["typescript",]]
--[["typescriptreaet",]]
--[["yaml",]]
--[[},]]
--[[})]]
--[[vim.keymap.set({ "x", "n" }, "<leader>fp", vim.cmd.Prettier)]]
--[[vim.keymap.set("i", "<C-s>", vim.cmd.Prettier)]]

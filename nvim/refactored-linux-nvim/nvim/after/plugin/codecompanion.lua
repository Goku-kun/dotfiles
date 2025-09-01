require("codecompanion").setup({
    strategies = {
        chat = {
            keymaps = {
                close = {
                    modes = { n = "<Esc>", i = "<Esc>" },
                    opts = {},
                },
            },
        },
        inline = {
            adapter = {
                name = "copilot",
                model = "gpt-5"
            },
        },
        cmd = {
            adapter = {
                name = "copilot",
                model = "gpt-5"
            },
        },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>cc",
    function() require("codecompanion").chat() end,
    { desc = "Code Companion Chat" }
)

vim.keymap.set("n", "<leader>ca",
    function() require("codecompanion").toggle() end,
    { desc = "Toggle Code Companion", }
)

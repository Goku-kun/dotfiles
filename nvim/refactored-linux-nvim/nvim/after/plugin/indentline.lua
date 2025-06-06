vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

--require("indent_blankline").setup {
    --buftype_exclude = { "terminal" },
    --filetype_exclude = { "help", "packer", "dashboard", "NvimTree", "Trouble" },
    --show_current_context = true,
    ----show_current_context_start = true,
    ----char = "▏",
    --char = "",
    --char_highlight_list = {
        --"IndentBlanklineIndent1",
        --"IndentBlanklineIndent2",
    --},
    --space_char_highlight_list = {
        --"IndentBlanklineIndent1",
        --"IndentBlanklineIndent2",
    --},
    --space_char_blankline = " ",
    --show_end_of_line = true,
    --context_patterns = {
        --"class",
        --"function",
        --"method",
        --"^if",
        --"^while",
        --"jsx_element",
        --"^for",
        --"^object",
        --"^table",
        --"block",
        --"arguments",
        --"if_statement",
        --"else_clause",
        --"jsx_element",
        --"jsx_self_closing_element",
        --"try_statement",
        --"catch_clause",
        --"import_statement",
        --"operation_type",
    --},
--}

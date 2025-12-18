-- ============================================================================
-- LUA - Snippets (focused on Neovim configuration)
-- ============================================================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- Function
	s(
		"fn",
		fmt(
			[[
function {}({})
    {}
end
]],
			{
				i(1, "name"),
				i(2),
				i(3, "-- body"),
			}
		)
	),

	-- Local function
	s(
		"lfn",
		fmt(
			[[
local function {}({})
    {}
end
]],
			{
				i(1, "name"),
				i(2),
				i(3, "-- body"),
			}
		)
	),

	-- Anonymous function
	s(
		"afn",
		fmt(
			[[
function({})
    {}
end
]],
			{
				i(1),
				i(2, "-- body"),
			}
		)
	),

	-- Require
	s(
		"req",
		fmt('local {} = require("{}")', {
			f(function(args)
				local parts = vim.split(args[1][1], ".", { plain = true })
				return parts[#parts] or "module"
			end, { 1 }),
			i(1, "module"),
		})
	),

	-- Protected require
	s(
		"preq",
		fmt(
			[[
local ok, {} = pcall(require, "{}")
if not ok then
    return
end
]],
			{
				i(2, "module"),
				i(1, "module"),
			}
		)
	),

	-- Module
	s(
		"mod",
		fmt(
			[[
local M = {{}}

{}

return M
]],
			{
				i(1, "-- module content"),
			}
		)
	),

	-- Neovim keymap
	s(
		"map",
		fmt(
			[[
vim.keymap.set("{}", "{}", {}, {{ desc = "{}" }})
]],
			{
				c(1, {
					t("n"),
					t("i"),
					t("v"),
					t("x"),
					t('{ "n", "v" }'),
				}),
				i(2, "lhs"),
				c(3, {
					sn(nil, { t('"'), i(1, "rhs"), t('"') }),
					sn(nil, {
						t({ "function()", "    " }),
						i(1, "-- body"),
						t({ "", "end" }),
					}),
				}),
				i(4, "description"),
			}
		)
	),

	-- Neovim autocommand
	s(
		"autocmd",
		fmt(
			[[
vim.api.nvim_create_autocmd("{}", {{
    group = vim.api.nvim_create_augroup("{}", {{ clear = true }}),
    pattern = "{}",
    callback = function({})
        {}
    end,
}})
]],
			{
				c(1, {
					t("BufEnter"),
					t("BufWritePre"),
					t("BufReadPost"),
					t("FileType"),
					t("VimEnter"),
					t("LspAttach"),
				}),
				i(2, "GroupName"),
				i(3, "*"),
				c(4, {
					t(""),
					t("ev"),
				}),
				i(5, "-- callback body"),
			}
		)
	),

	-- Neovim option
	s(
		"opt",
		fmt("vim.opt.{} = {}", {
			i(1, "option"),
			i(2, "value"),
		})
	),

	-- Neovim global variable
	s(
		"g",
		fmt("vim.g.{} = {}", {
			i(1, "variable"),
			i(2, "value"),
		})
	),

	-- If statement
	s(
		"if",
		fmt(
			[[
if {} then
    {}
end
]],
			{
				i(1, "condition"),
				i(2, "-- body"),
			}
		)
	),

	-- If-else
	s(
		"ife",
		fmt(
			[[
if {} then
    {}
else
    {}
end
]],
			{
				i(1, "condition"),
				i(2, "-- if body"),
				i(3, "-- else body"),
			}
		)
	),

	-- For loop (ipairs)
	s(
		"fori",
		fmt(
			[[
for {}, {} in ipairs({}) do
    {}
end
]],
			{
				i(1, "i"),
				i(2, "v"),
				i(3, "table"),
				i(4, "-- body"),
			}
		)
	),

	-- For loop (pairs)
	s(
		"forp",
		fmt(
			[[
for {}, {} in pairs({}) do
    {}
end
]],
			{
				i(1, "k"),
				i(2, "v"),
				i(3, "table"),
				i(4, "-- body"),
			}
		)
	),

	-- For loop (numeric)
	s(
		"forn",
		fmt(
			[[
for {} = {}, {} do
    {}
end
]],
			{
				i(1, "i"),
				i(2, "1"),
				i(3, "10"),
				i(4, "-- body"),
			}
		)
	),

	-- Print
	s("p", fmt("print({})", { i(1, "value") })),

	-- vim.print (pretty print)
	s("vp", fmt("vim.print({})", { i(1, "value") })),

	-- vim.inspect
	s("vi", fmt("print(vim.inspect({}))", { i(1, "value") })),

	-- Local variable
	s("l", fmt("local {} = {}", { i(1, "name"), i(2, "value") })),

	-- Return
	s("ret", fmt("return {}", { i(1, "value") })),
}

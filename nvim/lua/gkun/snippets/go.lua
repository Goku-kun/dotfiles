-- ============================================================================
-- GO - Snippets
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
	-- if err != nil (most common Go pattern)
	s(
		"iferr",
		fmt(
			[[
if err != nil {{
	{}
}}
]],
			{
				c(1, {
					sn(nil, { t("return "), i(1, "err") }),
					sn(nil, { t('return fmt.Errorf("'), i(1, "context"), t(': %w", err)') }),
					sn(nil, { t("log.Fatal(err)") }),
					sn(nil, { t('log.Printf("'), i(1, "error"), t(': %v", err)') }),
				}),
			}
		)
	),

	-- Function
	s(
		"fn",
		fmt(
			[[
func {}({}) {} {{
	{}
}}
]],
			{
				i(1, "name"),
				i(2),
				c(3, {
					t(""),
					sn(nil, { t("error") }),
					sn(nil, { t("("), i(1, "Type"), t(", error)") }),
					sn(nil, { i(1, "Type") }),
				}),
				i(4, "// body"),
			}
		)
	),

	-- Method
	s(
		"meth",
		fmt(
			[[
func ({} *{}) {}({}) {} {{
	{}
}}
]],
			{
				i(1, "r"),
				i(2, "Receiver"),
				i(3, "Method"),
				i(4),
				c(5, {
					t(""),
					sn(nil, { t("error") }),
					sn(nil, { t("("), i(1, "Type"), t(", error)") }),
				}),
				i(6, "// body"),
			}
		)
	),

	-- Struct
	s(
		"struct",
		fmt(
			[[
type {} struct {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(2, "// fields"),
			}
		)
	),

	-- Interface
	s(
		"interface",
		fmt(
			[[
type {} interface {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(2, "// methods"),
			}
		)
	),

	-- Test function
	s(
		"test",
		fmt(
			[[
func Test{}(t *testing.T) {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(2, "// test body"),
			}
		)
	),

	-- Table-driven test
	s(
		"ttest",
		fmt(
			[[
func Test{}(t *testing.T) {{
	tests := []struct {{
		name string
		{}
		want {}
	}}{{
		{{
			name: "{}",
			{}
		}},
	}}

	for _, tt := range tests {{
		t.Run(tt.name, func(t *testing.T) {{
			got := {}
			if got != tt.want {{
				t.Errorf("{} = %v, want %v", got, tt.want)
			}}
		}})
	}}
}}
]],
			{
				i(1, "Name"),
				i(2, "input Type"),
				i(3, "Type"),
				i(4, "case name"),
				i(5, "// test case"),
				i(6, "// function call"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
			}
		)
	),

	-- Benchmark
	s(
		"bench",
		fmt(
			[[
func Benchmark{}(b *testing.B) {{
	for i := 0; i < b.N; i++ {{
		{}
	}}
}}
]],
			{
				i(1, "Name"),
				i(2, "// benchmark body"),
			}
		)
	),

	-- HTTP handler
	s(
		"handler",
		fmt(
			[[
func {}(w http.ResponseWriter, r *http.Request) {{
	{}
}}
]],
			{
				i(1, "handlerName"),
				i(2, "// handler body"),
			}
		)
	),

	-- Goroutine with error channel
	s(
		"go",
		fmt(
			[[
go func() {{
	{}
}}()
]],
			{
				i(1, "// goroutine body"),
			}
		)
	),

	-- Defer
	s(
		"defer",
		fmt(
			[[
defer func() {{
	{}
}}()
]],
			{
				i(1, "// deferred code"),
			}
		)
	),

	-- Select statement
	s(
		"sel",
		fmt(
			[[
select {{
case {} := <-{}:
	{}
case <-ctx.Done():
	return ctx.Err()
}}
]],
			{
				i(1, "v"),
				i(2, "ch"),
				i(3, "// handle value"),
			}
		)
	),

	-- Context with timeout
	s(
		"ctxtimeout",
		fmt(
			[[
ctx, cancel := context.WithTimeout({}, {}*time.{})
defer cancel()
]],
			{
				c(1, {
					t("context.Background()"),
					t("ctx"),
				}),
				i(2, "5"),
				c(3, {
					t("Second"),
					t("Minute"),
					t("Millisecond"),
				}),
			}
		)
	),

	-- Main function
	s(
		"main",
		fmt(
			[[
func main() {{
	{}
}}
]],
			{
				i(1, "// main body"),
			}
		)
	),

	-- Package declaration with import
	s(
		"pkg",
		fmt(
			[[
package {}

import (
	"{}"
)
]],
			{
				i(1, "main"),
				i(2, "fmt"),
			}
		)
	),

	-- Printf
	s("pf", fmt('fmt.Printf("{}", {})', { i(1, "%v\\n"), i(2, "value") })),

	-- Println
	s("pl", fmt("fmt.Println({})", { i(1, "value") })),

	-- Errorf
	s("errf", fmt('fmt.Errorf("{}: %w", {})', { i(1, "context"), i(2, "err") })),
}

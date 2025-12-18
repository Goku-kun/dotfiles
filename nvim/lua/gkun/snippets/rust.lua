-- ============================================================================
-- RUST - Snippets
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
fn {}({}) {} {{
    {}
}}
]],
			{
				i(1, "name"),
				i(2),
				c(3, {
					t(""),
					sn(nil, { t("-> "), i(1, "Type") }),
					sn(nil, { t("-> Result<"), i(1, "T"), t(", "), i(2, "E"), t(">") }),
					sn(nil, { t("-> Option<"), i(1, "T"), t(">") }),
				}),
				i(4, "todo!()"),
			}
		)
	),

	-- Public function
	s(
		"pubfn",
		fmt(
			[[
pub fn {}({}) {} {{
    {}
}}
]],
			{
				i(1, "name"),
				i(2),
				c(3, {
					t(""),
					sn(nil, { t("-> "), i(1, "Type") }),
					sn(nil, { t("-> Result<"), i(1, "T"), t(", "), i(2, "Error"), t(">") }),
				}),
				i(4, "todo!()"),
			}
		)
	),

	-- Struct
	s(
		"struct",
		fmt(
			[[
{}struct {} {{
    {}
}}
]],
			{
				c(1, {
					t(""),
					t("pub "),
					t("#[derive(Debug, Clone)]\n"),
					t("#[derive(Debug, Clone, PartialEq, Eq)]\n"),
					t("#[derive(Debug, Clone, Serialize, Deserialize)]\n"),
				}),
				i(2, "Name"),
				i(3, "// fields"),
			}
		)
	),

	-- Enum
	s(
		"enum",
		fmt(
			[[
{}enum {} {{
    {}
}}
]],
			{
				c(1, {
					t(""),
					t("pub "),
					t("#[derive(Debug, Clone)]\n"),
					t("#[derive(Debug, Clone, PartialEq, Eq)]\n"),
				}),
				i(2, "Name"),
				i(3, "// variants"),
			}
		)
	),

	-- Impl block
	s(
		"impl",
		fmt(
			[[
impl {} {{
    {}
}}
]],
			{
				i(1, "Type"),
				i(2, "// methods"),
			}
		)
	),

	-- Impl trait for type
	s(
		"impltrait",
		fmt(
			[[
impl {} for {} {{
    {}
}}
]],
			{
				i(1, "Trait"),
				i(2, "Type"),
				i(3, "// trait methods"),
			}
		)
	),

	-- Trait definition
	s(
		"trait",
		fmt(
			[[
pub trait {} {{
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
#[test]
fn {}() {{
    {}
}}
]],
			{
				i(1, "test_name"),
				i(2, "// test body"),
			}
		)
	),

	-- Test module
	s(
		"testmod",
		fmt(
			[[
#[cfg(test)]
mod tests {{
    use super::*;

    #[test]
    fn {}() {{
        {}
    }}
}}
]],
			{
				i(1, "test_name"),
				i(2, "// test body"),
			}
		)
	),

	-- Match expression
	s(
		"match",
		fmt(
			[[
match {} {{
    {} => {},
    _ => {},
}}
]],
			{
				i(1, "value"),
				i(2, "pattern"),
				i(3, "result"),
				i(4, "todo!()"),
			}
		)
	),

	-- Match Result
	s(
		"matchr",
		fmt(
			[[
match {} {{
    Ok({}) => {},
    Err({}) => {},
}}
]],
			{
				i(1, "result"),
				i(2, "value"),
				i(3, "// handle success"),
				i(4, "e"),
				i(5, "// handle error"),
			}
		)
	),

	-- Match Option
	s(
		"matcho",
		fmt(
			[[
match {} {{
    Some({}) => {},
    None => {},
}}
]],
			{
				i(1, "option"),
				i(2, "value"),
				i(3, "// handle some"),
				i(4, "// handle none"),
			}
		)
	),

	-- if let
	s(
		"iflet",
		fmt(
			[[
if let {} = {} {{
    {}
}}
]],
			{
				c(1, {
					sn(nil, { t("Some("), i(1, "value"), t(")") }),
					sn(nil, { t("Ok("), i(1, "value"), t(")") }),
					sn(nil, { i(1, "Pattern") }),
				}),
				i(2, "expr"),
				i(3, "// body"),
			}
		)
	),

	-- Derive macro
	s(
		"derive",
		fmt("#[derive({})]", {
			c(1, {
				t("Debug, Clone"),
				t("Debug, Clone, PartialEq, Eq"),
				t("Debug, Clone, Serialize, Deserialize"),
				t("Debug, Clone, Default"),
				t("Debug, Clone, Copy, PartialEq, Eq, Hash"),
			}),
		})
	),

	-- println!
	s("pl", fmt('println!("{}", {});', { i(1, "{}"), i(2, "value") })),

	-- dbg!
	s("dbg", fmt("dbg!(&{});", { i(1, "value") })),

	-- todo!
	s("todo", t('todo!("implement")')),

	-- unimplemented!
	s("unimp", t("unimplemented!()")),

	-- Main function
	s(
		"main",
		fmt(
			[[
fn main() {{
    {}
}}
]],
			{
				i(1, "// main body"),
			}
		)
	),

	-- Main with Result
	s(
		"mainr",
		fmt(
			[[
fn main() -> Result<(), Box<dyn std::error::Error>> {{
    {}

    Ok(())
}}
]],
			{
				i(1, "// main body"),
			}
		)
	),

	-- Use statement
	s("use", fmt("use {};", { i(1, "std::collections::HashMap") })),

	-- Module declaration
	s("mod", fmt("mod {};", { i(1, "module_name") })),

	-- Public module
	s("pubmod", fmt("pub mod {};", { i(1, "module_name") })),
}

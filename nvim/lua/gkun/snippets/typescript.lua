-- ============================================================================
-- TYPESCRIPT/JAVASCRIPT/REACT - Snippets
-- ============================================================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

-- Helper: Get filename without extension (for component name)
local function filename()
	local name = vim.fn.expand("%:t:r")
	-- Convert kebab-case or snake_case to PascalCase
	return name:gsub("^%l", string.upper):gsub("[_-](%l)", function(c)
		return c:upper()
	end)
end

return {
	-- React Functional Component
	s(
		"rfc",
		fmt(
			[[
interface {}Props {{
  {}
}}

export function {}({{ {} }}: {}Props) {{
  return (
    <div>
      {}
    </div>
  )
}}
]],
			{
				f(filename, {}),
				i(1, "// props"),
				f(filename, {}),
				i(2),
				f(filename, {}),
				i(3, "// content"),
			}
		)
	),

	-- React Functional Component (arrow)
	s(
		"rfca",
		fmt(
			[[
interface {}Props {{
  {}
}}

export const {} = ({{ {} }}: {}Props) => {{
  return (
    <div>
      {}
    </div>
  )
}}
]],
			{
				f(filename, {}),
				i(1, "// props"),
				f(filename, {}),
				i(2),
				f(filename, {}),
				i(3, "// content"),
			}
		)
	),

	-- useState hook
	s(
		"us",
		fmt("const [{}, set{}] = useState{}({})", {
			i(1, "state"),
			f(function(args)
				return args[1][1]:gsub("^%l", string.upper)
			end, { 1 }),
			c(2, {
				t(""),
				sn(nil, { t("<"), i(1, "Type"), t(">") }),
			}),
			i(3, "initialValue"),
		})
	),

	-- useEffect hook
	s(
		"ue",
		fmt(
			[[
useEffect(() => {{
  {}
  {}
}}, [{}])
]],
			{
				i(1, "// effect"),
				c(2, {
					t(""),
					sn(nil, {
						t({ "", "  return () => {", "    " }),
						i(1, "// cleanup"),
						t({ "", "  }" }),
					}),
				}),
				i(3),
			}
		)
	),

	-- useCallback hook
	s(
		"ucb",
		fmt(
			[[
const {} = useCallback(({}) => {{
  {}
}}, [{}])
]],
			{
				i(1, "callback"),
				i(2),
				i(3, "// body"),
				i(4),
			}
		)
	),

	-- useMemo hook
	s(
		"um",
		fmt(
			[[
const {} = useMemo(() => {{
  return {}
}}, [{}])
]],
			{
				i(1, "value"),
				i(2, "computedValue"),
				i(3),
			}
		)
	),

	-- TypeScript interface
	s(
		"int",
		fmt(
			[[
interface {} {{
  {}
}}
]],
			{
				i(1, "Name"),
				i(2, "// properties"),
			}
		)
	),

	-- TypeScript type
	s(
		"type",
		fmt(
			[[
type {} = {}
]],
			{
				i(1, "Name"),
				i(2, "{}"),
			}
		)
	),

	-- Arrow function
	s(
		"af",
		fmt(
			[[
const {} = ({}) => {{
  {}
}}
]],
			{
				i(1, "name"),
				i(2),
				i(3, "// body"),
			}
		)
	),

	-- Async arrow function
	s(
		"aaf",
		fmt(
			[[
const {} = async ({}) => {{
  {}
}}
]],
			{
				i(1, "name"),
				i(2),
				i(3, "// body"),
			}
		)
	),

	-- Console log
	s("cl", fmt("console.log({})", { i(1, "value") })),

	-- Console log with label
	s(
		"cll",
		fmt('console.log("{}: ", {})', {
			i(1, "label"),
			f(function(args)
				return args[1][1]
			end, { 1 }),
		})
	),

	-- Try-catch block
	s(
		"tc",
		fmt(
			[[
try {{
  {}
}} catch (error) {{
  {}
}}
]],
			{
				i(1, "// try"),
				i(2, "console.error(error)"),
			}
		)
	),

	-- Import statement
	s(
		"imp",
		fmt('import {{ {} }} from "{}"', {
			i(2, "module"),
			i(1, "package"),
		})
	),

	-- Default import
	s(
		"impd",
		fmt('import {} from "{}"', {
			i(2, "module"),
			i(1, "package"),
		})
	),

	-- Export default
	s("expd", fmt("export default {}", { i(1, "name") })),
}

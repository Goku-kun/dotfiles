-- ============================================================================
-- ALL FILETYPES - Universal Snippets
-- ============================================================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

-- Helper: Get current date
local function date()
	return os.date("%Y-%m-%d")
end

-- Helper: Get current datetime
local function datetime()
	return os.date("%Y-%m-%d %H:%M:%S")
end

return {
	-- TODO comment
	s("todo", {
		t("TODO: "),
		i(1, "description"),
	}),

	-- FIXME comment
	s("fixme", {
		t("FIXME: "),
		i(1, "description"),
	}),

	-- NOTE comment
	s("note", {
		t("NOTE: "),
		i(1, "description"),
	}),

	-- Current date
	s("date", {
		f(date, {}),
	}),

	-- Current datetime
	s("datetime", {
		f(datetime, {}),
	}),

	-- Lorem ipsum
	s("lorem", {
		t(
			"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
		),
	}),
}

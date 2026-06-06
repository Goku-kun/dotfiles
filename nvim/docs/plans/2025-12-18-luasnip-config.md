# LuaSnip Configuration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add full-featured LuaSnip configuration with keybindings, choice node support in nvim-cmp, and custom snippets in Lua/JSON formats.

**Architecture:** Create dedicated luasnip.lua config file, custom snippets directory structure, and modify existing lsp.lua for cmp integration. Snippets load from friendly-snippets + custom Lua/JSON sources.

**Tech Stack:** LuaSnip v2, nvim-cmp, friendly-snippets, Neovim 0.11+

---

### Task 1: Create LuaSnip Configuration File

**Files:**
- Create: `after/plugin/luasnip.lua`

**Step 1: Create the main LuaSnip configuration**

```lua
-- ============================================================================
-- LUASNIP CONFIGURATION
-- ============================================================================
-- Full-featured snippet engine setup with:
-- - Keybindings: <C-k> forward, <C-j> backward (insert mode)
-- - Choice nodes integrated with nvim-cmp
-- - Custom snippets from lua/gkun/snippets/ (Lua format)
-- - Custom snippets from snippets/ (JSON/VSCode format)
-- - friendly-snippets pre-loaded
-- ============================================================================

local ls = require("luasnip")
local types = require("luasnip.util.types")

-- ============================================================================
-- CORE CONFIGURATION
-- ============================================================================

ls.setup({
	-- Remember last snippet to jump back into it
	history = true,

	-- Update dynamic snippets as you type
	updateevents = "TextChanged,TextChangedI",

	-- Enable autosnippets (snippets that expand without trigger)
	enable_autosnippets = true,

	-- Highlight configuration for visual feedback
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "DiagnosticWarn" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "DiagnosticInfo" } },
			},
		},
	},

	-- Clean up snippets when leaving them
	region_check_events = "CursorMoved",
	delete_check_events = "TextChanged",
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

-- Jump forward in snippet (<C-k> in insert/select mode)
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "LuaSnip: Expand or jump forward" })

-- Jump backward in snippet (<C-j> in insert/select mode)
vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "LuaSnip: Jump backward" })

-- Cycle through choice nodes (<C-e> in insert mode)
vim.keymap.set({ "i", "s" }, "<C-e>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true, desc = "LuaSnip: Cycle choice" })

-- ============================================================================
-- SNIPPET LOADERS
-- ============================================================================

-- Load friendly-snippets (VSCode format)
require("luasnip.loaders.from_vscode").lazy_load()

-- Load custom Lua snippets from lua/gkun/snippets/
require("luasnip.loaders.from_lua").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/lua/gkun/snippets" },
})

-- Load custom JSON snippets from snippets/
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- ============================================================================
-- FILETYPE EXTENSIONS
-- ============================================================================

-- React filetypes inherit from JavaScript/TypeScript
ls.filetype_extend("javascriptreact", { "javascript", "html" })
ls.filetype_extend("typescriptreact", { "typescript", "javascript", "html" })
ls.filetype_extend("typescript", { "javascript" })

-- Flutter/Dart extensions
ls.filetype_extend("dart", { "flutter" })
```

**Step 2: Verify file created**

Open Neovim and run:
```vim
:e ~/.config/nvim/after/plugin/luasnip.lua
```

Expected: File opens with the configuration.

**Step 3: Commit**

```bash
git add after/plugin/luasnip.lua
git commit -m "feat: add LuaSnip configuration with keybindings and loaders"
```

---

### Task 2: Create Custom Snippets Directory Structure

**Files:**
- Create: `lua/gkun/snippets/` directory
- Create: `snippets/package.json`

**Step 1: Create directories**

```bash
mkdir -p ~/.config/nvim/lua/gkun/snippets
mkdir -p ~/.config/nvim/snippets
```

**Step 2: Create JSON snippets manifest**

Create `snippets/package.json`:

```json
{
  "name": "custom-snippets",
  "contributes": {
    "snippets": []
  }
}
```

**Step 3: Verify structure**

```bash
ls -la ~/.config/nvim/lua/gkun/snippets/
ls -la ~/.config/nvim/snippets/
```

Expected: Both directories exist, package.json present.

**Step 4: Commit**

```bash
git add lua/gkun/snippets/.gitkeep snippets/package.json
git commit -m "feat: add custom snippets directory structure"
```

---

### Task 3: Create All-Filetype Snippets

**Files:**
- Create: `lua/gkun/snippets/all.lua`

**Step 1: Create universal snippets**

```lua
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
		t("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
	}),
}
```

**Step 2: Test in Neovim**

1. Open any file: `:e /tmp/test.txt`
2. Enter insert mode, type `todo` and press `<C-y>` to confirm
3. Should expand to `TODO: description` with cursor on "description"
4. Press `<C-k>` to exit snippet

**Step 3: Commit**

```bash
git add lua/gkun/snippets/all.lua
git commit -m "feat: add universal snippets (todo, fixme, date)"
```

---

### Task 4: Create TypeScript/JavaScript/React Snippets

**Files:**
- Create: `lua/gkun/snippets/typescript.lua`

**Step 1: Create TypeScript/React snippets**

```lua
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
```

**Step 2: Test in Neovim**

1. Open a TypeScript file: `:e /tmp/test.tsx`
2. Type `rfc` and confirm - should create full component
3. Type `us` and confirm - should create useState with choice for type annotation
4. Press `<C-e>` at the choice node to cycle options

**Step 3: Commit**

```bash
git add lua/gkun/snippets/typescript.lua
git commit -m "feat: add TypeScript/React snippets (rfc, hooks, etc)"
```

---

### Task 5: Create Dart/Flutter Snippets

**Files:**
- Create: `lua/gkun/snippets/dart.lua`

**Step 1: Create Dart/Flutter snippets**

```lua
-- ============================================================================
-- DART/FLUTTER - Snippets
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

-- Helper: Get filename without extension (for class name)
local function classname()
	local name = vim.fn.expand("%:t:r")
	-- Convert snake_case to PascalCase
	return name:gsub("^%l", string.upper):gsub("_(%l)", function(c)
		return c:upper()
	end)
end

return {
	-- StatelessWidget
	s(
		"stl",
		fmt(
			[[
class {} extends StatelessWidget {{
  const {}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return {};
  }}
}}
]],
			{
				f(classname, {}),
				f(classname, {}),
				c(1, {
					sn(nil, {
						t("const Placeholder()"),
					}),
					sn(nil, {
						t({ "Container(", "      child: " }),
						i(1, "child"),
						t({ ",", "    )" }),
					}),
					sn(nil, {
						t({ "Column(", "      children: [", "        " }),
						i(1),
						t({ ",", "      ],", "    )" }),
					}),
				}),
			}
		)
	),

	-- StatefulWidget
	s(
		"stf",
		fmt(
			[[
class {} extends StatefulWidget {{
  const {}({{super.key}});

  @override
  State<{}> createState() => _{}State();
}}

class _{}State extends State<{}> {{
  @override
  Widget build(BuildContext context) {{
    return {};
  }}
}}
]],
			{
				f(classname, {}),
				f(classname, {}),
				f(classname, {}),
				f(classname, {}),
				f(classname, {}),
				f(classname, {}),
				i(1, "const Placeholder()"),
			}
		)
	),

	-- BLoC
	s(
		"bloc",
		fmt(
			[[
class {}Bloc extends Bloc<{}Event, {}State> {{
  {}Bloc() : super({}Initial()) {{
    on<{}Event>(_on{});
  }}

  Future<void> _on{}(
    {}Event event,
    Emitter<{}State> emit,
  ) async {{
    {}
  }}
}}
]],
			{
				i(1, "Feature"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				i(2, "// handle event"),
			}
		)
	),

	-- BLoC Event
	s(
		"blocevent",
		fmt(
			[[
sealed class {}Event {{}}

final class {}Started extends {}Event {{}}

final class {} extends {}Event {{
  const {}({{required this.{}}});
  final {} {};
}}
]],
			{
				i(1, "Feature"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				i(2, "EventName"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 2 }),
				i(3, "param"),
				i(4, "Type"),
				f(function(args)
					return args[1][1]
				end, { 3 }),
			}
		)
	),

	-- BLoC State
	s(
		"blocstate",
		fmt(
			[[
sealed class {}State {{}}

final class {}Initial extends {}State {{}}

final class {}Loading extends {}State {{}}

final class {}Success extends {}State {{
  const {}Success({{required this.{}}});
  final {} {};
}}

final class {}Failure extends {}State {{
  const {}Failure({{required this.message}});
  final String message;
}}
]],
			{
				i(1, "Feature"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				i(2, "data"),
				i(3, "Type"),
				f(function(args)
					return args[1][1]
				end, { 2 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
			}
		)
	),

	-- Freezed class
	s(
		"freezed",
		fmt(
			[[
@freezed
class {} with _${} {{
  const factory {}({{
    {}
  }}) = _{};
}}
]],
			{
				i(1, "ClassName"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				f(function(args)
					return args[1][1]
				end, { 1 }),
				i(2, "required String field,"),
				f(function(args)
					return args[1][1]
				end, { 1 }),
			}
		)
	),

	-- initState
	s(
		"initstate",
		fmt(
			[[
@override
void initState() {{
  super.initState();
  {}
}}
]],
			{
				i(1, "// initialization"),
			}
		)
	),

	-- dispose
	s(
		"dispose",
		fmt(
			[[
@override
void dispose() {{
  {}
  super.dispose();
}}
]],
			{
				i(1, "// cleanup"),
			}
		)
	),

	-- BlocBuilder
	s(
		"blocbuilder",
		fmt(
			[[
BlocBuilder<{}, {}>(
  builder: (context, state) {{
    return {};
  }},
)
]],
			{
				i(1, "Bloc"),
				i(2, "State"),
				i(3, "const Placeholder()"),
			}
		)
	),

	-- BlocListener
	s(
		"bloclistener",
		fmt(
			[[
BlocListener<{}, {}>(
  listener: (context, state) {{
    {}
  }},
  child: {},
)
]],
			{
				i(1, "Bloc"),
				i(2, "State"),
				i(3, "// handle state change"),
				i(4, "child"),
			}
		)
	),

	-- BlocConsumer
	s(
		"blocconsumer",
		fmt(
			[[
BlocConsumer<{}, {}>(
  listener: (context, state) {{
    {}
  }},
  builder: (context, state) {{
    return {};
  }},
)
]],
			{
				i(1, "Bloc"),
				i(2, "State"),
				i(3, "// handle state change"),
				i(4, "const Placeholder()"),
			}
		)
	),
}
```

**Step 2: Test in Neovim**

1. Open a Dart file: `:e /tmp/test_widget.dart`
2. Type `stl` and confirm - should create StatelessWidget with class name from filename
3. Type `bloc` and confirm - type "Auth" and watch all references update

**Step 3: Commit**

```bash
git add lua/gkun/snippets/dart.lua
git commit -m "feat: add Dart/Flutter snippets (widgets, BLoC)"
```

---

### Task 6: Create Go Snippets

**Files:**
- Create: `lua/gkun/snippets/go.lua`

**Step 1: Create Go snippets**

```lua
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
```

**Step 2: Test in Neovim**

1. Open a Go file: `:e /tmp/main.go`
2. Type `iferr` and confirm - cycle through error handling choices with `<C-e>`
3. Type `fn` and confirm - see return type choices

**Step 3: Commit**

```bash
git add lua/gkun/snippets/go.lua
git commit -m "feat: add Go snippets (iferr, struct, test, etc)"
```

---

### Task 7: Create Rust Snippets

**Files:**
- Create: `lua/gkun/snippets/rust.lua`

**Step 1: Create Rust snippets**

```lua
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
```

**Step 2: Test in Neovim**

1. Open a Rust file: `:e /tmp/main.rs`
2. Type `struct` and confirm - cycle through derive options with `<C-e>`
3. Type `fn` and confirm - cycle through return type options

**Step 3: Commit**

```bash
git add lua/gkun/snippets/rust.lua
git commit -m "feat: add Rust snippets (fn, struct, impl, match, etc)"
```

---

### Task 8: Create Lua Snippets (for Neovim config)

**Files:**
- Create: `lua/gkun/snippets/lua.lua`

**Step 1: Create Lua snippets**

```lua
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
```

**Step 2: Test in Neovim**

1. Open a Lua file: `:e /tmp/test.lua`
2. Type `req` and confirm - type a module path and see the local var update
3. Type `map` and confirm - cycle through mode options

**Step 3: Commit**

```bash
git add lua/gkun/snippets/lua.lua
git commit -m "feat: add Lua/Neovim snippets (keymap, autocmd, etc)"
```

---

### Task 9: Update lsp.lua for Enhanced cmp Integration

**Files:**
- Modify: `after/plugin/lsp.lua:31-88` (cmp setup section)

**Step 1: Update the cmp.setup section**

Replace the current cmp.setup (lines ~31-88) with:

```lua
-- ============================================================================
-- COMPLETION SETUP - nvim-cmp Configuration
-- ============================================================================

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Note: LuaSnip is now configured in after/plugin/luasnip.lua
-- We only need cmp integration here

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	-- Keybindings for completion menu
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		-- Tab is reserved for Copilot
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
	}),

	-- Completion sources (order matters - higher priority first)
	sources = cmp.config.sources({
		{ name = "luasnip", priority = 1000 }, -- Snippet completions (highest)
		{ name = "nvim_lsp", priority = 900 }, -- LSP completions
		{ name = "nvim_lua", priority = 800 }, -- Neovim Lua API completions
		{ name = "path", priority = 700 }, -- File path completions
	}, {
		{ name = "buffer", keyword_length = 3, priority = 500 }, -- Buffer completions
	}),

	-- Completion menu appearance
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- Formatting of completion items
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons (optional - you can customize these)
			local kind_icons = {
				Text = "",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰇽",
				Variable = "󰂡",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "󰅲",
			}

			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				luasnip = "[Snip]",
				buffer = "[Buf]",
				path = "[Path]",
			})[entry.source.name]

			return vim_item
		end,
	},

	-- Experimental features
	experimental = {
		ghost_text = false, -- Conflicts with Copilot
	},
})
```

**Step 2: Remove the old friendly-snippets loader**

Delete this line from lsp.lua (around line 35):
```lua
-- DELETE THIS LINE:
require("luasnip.loaders.from_vscode").lazy_load()
```

This is now handled in `after/plugin/luasnip.lua`.

**Step 3: Verify changes**

1. Open Neovim
2. Edit a TypeScript file: `:e /tmp/test.tsx`
3. Type `rfc` - should see snippet in completion menu with `[Snip]` label
4. Confirm with `<C-y>`, navigate with `<C-k>`/`<C-j>`

**Step 4: Commit**

```bash
git add after/plugin/lsp.lua
git commit -m "refactor: update cmp config for LuaSnip integration"
```

---

### Task 10: Final Verification

**Step 1: Restart Neovim and verify all components**

1. Run `:checkhealth luasnip` - should show no errors
2. Run `:LuaSnipListAvailable` - should show loaded snippets by filetype

**Step 2: Test each language**

| File Type | Snippet | Expected Result |
|-----------|---------|-----------------|
| Any | `todo` | `TODO: description` |
| TypeScript | `rfc` | Full React component |
| TypeScript | `us` | useState with choice node |
| Dart | `stl` | StatelessWidget |
| Go | `iferr` | if err != nil with choices |
| Rust | `fn` | Function with return type choices |
| Lua | `map` | vim.keymap.set |

**Step 3: Test keybindings**

1. Expand a snippet with multiple placeholders
2. Press `<C-k>` - jumps forward
3. Press `<C-j>` - jumps backward
4. At a choice node, press `<C-e>` - cycles choices

**Step 4: Final commit**

```bash
git add -A
git commit -m "feat: complete LuaSnip configuration with custom snippets"
```

---

## Summary

**Files created:**
- `after/plugin/luasnip.lua` - Main configuration
- `lua/gkun/snippets/all.lua` - Universal snippets
- `lua/gkun/snippets/typescript.lua` - TS/JS/React snippets
- `lua/gkun/snippets/dart.lua` - Flutter/Dart snippets
- `lua/gkun/snippets/go.lua` - Go snippets
- `lua/gkun/snippets/rust.lua` - Rust snippets
- `lua/gkun/snippets/lua.lua` - Lua/Neovim snippets
- `snippets/package.json` - JSON snippets manifest

**Files modified:**
- `after/plugin/lsp.lua` - Updated cmp integration

**Keybindings:**
- `<C-k>` (insert) - Jump forward in snippet
- `<C-j>` (insert) - Jump backward in snippet
- `<C-e>` (insert) - Cycle choice node

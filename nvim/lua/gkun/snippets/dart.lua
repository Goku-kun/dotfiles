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

# LuaSnip Configuration Design

## Overview

Full-featured LuaSnip configuration with snippet navigation, choice node support in nvim-cmp, and custom snippets in both Lua and JSON formats.

## Requirements

- Snippet navigation: `<C-k>` forward, `<C-j>` backward (insert mode only)
- Choice nodes visible in nvim-cmp completion menu
- Custom snippets in Lua format (powerful, dynamic)
- Custom snippets in JSON format (simple, VSCode-compatible)
- Pre-loaded friendly-snippets for all languages
- Languages: TypeScript/JavaScript/React, Flutter/Dart, Go, Rust, C/C++, Lua

## File Structure

```
~/.config/nvim/
├── after/plugin/
│   └── luasnip.lua              # Main LuaSnip configuration (NEW)
├── lua/gkun/
│   └── snippets/                # Custom Lua snippets (NEW)
│       ├── all.lua              # All filetypes
│       ├── typescript.lua       # TS/JS/React
│       ├── dart.lua             # Flutter/Dart
│       ├── go.lua               # Go
│       ├── rust.lua             # Rust
│       └── lua.lua              # Lua
├── snippets/                    # JSON/VSCode snippets (NEW)
│   └── package.json             # Required manifest
└── after/plugin/lsp.lua         # Modified: cmp integration
```

## Component Details

### 1. Main Configuration (`after/plugin/luasnip.lua`)

Core setup:
- Enable jsregexp for regex support
- Set history=true for jumping back to previous snippets
- Enable updateevents for live placeholder updates
- Configure region_check and delete_check for clean exits

Keybindings (conditional - only active inside snippets):
- `<C-k>` in insert/select mode: jump forward
- `<C-j>` in insert/select mode: jump backward

Loaders:
- friendly-snippets (VSCode format, lazy loaded)
- Custom Lua snippets from `lua/gkun/snippets/`
- Custom JSON snippets from `snippets/`

Filetype extensions:
- javascriptreact extends javascript
- typescriptreact extends typescript, javascript
- typescript extends javascript

### 2. nvim-cmp Integration (`after/plugin/lsp.lua`)

Changes:
- Add luasnip_choice source for choice nodes in menu
- Adjust source priority (snippets higher)
- Add `[Choice]` formatting label
- Ensure keybindings work with cmp

Source order:
1. luasnip (snippets)
2. nvim_lsp (LSP completions)
3. nvim_lua (Neovim Lua API)
4. path (file paths)
5. luasnip_choice (choice nodes)
6. buffer (buffer words)

### 3. Custom Snippets

Lua snippets (powerful, dynamic):

| File | Snippets |
|------|----------|
| all.lua | todo, fixme, note, date, uuid |
| typescript.lua | rfc, useState, useEffect, interface, arrow |
| dart.lua | stl, stf, bloc, freezed |
| go.lua | iferr, func, struct, interface, test |
| rust.lua | fn, impl, struct, enum, test, derive |
| lua.lua | fn, lfn, req, mod |

JSON snippets:
- Simple format for quick additions
- Compatible with VSCode snippet imports

## Dependencies

Already installed (no changes to lazy.lua):
- L3MON4D3/LuaSnip v2.*
- saadparwaiz1/cmp_luasnip
- rafamadriz/friendly-snippets

## Notes

- Keybindings don't conflict with quickfix (C-j/C-k in normal mode)
- Tab reserved for Copilot (unchanged)
- Snippet expansion via cmp confirm (<C-y>)

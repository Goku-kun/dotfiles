# dotfiles

Configuration files for shells, editors, and utilities.

## What's in here

| Path                                    | Purpose                                  |
| --------------------------------------- | ---------------------------------------- |
| `nvim/`                                 | Neovim config (mirrors `~/.config/nvim`) |
| `alacritty/`                            | Alacritty terminal config                |
| `ghostty/`                              | Ghostty terminal config                  |
| `zsh/.zshrc`                            | Zsh shell config                         |
| `tmux-conf/`                            | tmux config                              |
| `windows-terminal/`, `remap-for-linux/` | Platform-specific extras                 |
| `Makefile`                              | One-stop installer/sync targets          |

## Quick start (macOS)

```sh
git clone <this-repo-url> ~/programming/dotfiles
cd ~/programming/dotfiles
make install_nvim_mac
```

`install_nvim_mac` will:

1. Copy `nvim/` → `~/.config/nvim/`.
2. Install Homebrew runtime deps (`tree-sitter-cli`, `ripgrep`, `fd`, `node`, `python`, `rustup`).
3. Install Neovim itself.

On first `nvim` launch, lazy.nvim installs plugins (from `nvim/lazy-lock.json`), mason installs LSP servers, and nvim-treesitter compiles parsers via `tree-sitter-cli`.

## Prerequisites

- **Neovim 0.12+** — required by this config (uses nvim-treesitter `main` branch).
- **Xcode Command Line Tools** (macOS) — needed for any compilation. Install with `xcode-select --install`.
- **Homebrew** (macOS) — used by the install targets.
- **`tree-sitter-cli`** — required by nvim-treesitter to compile parsers locally. The brew formula is `tree-sitter-cli` (NOT `tree-sitter`, which is just the C library).
- A **Nerd Font** for completion menu icons and diagnostic glyphs. Install one of your choosing:
  ```sh
  brew install --cask font-jetbrains-mono-nerd-font
  ```

## Detailed targets

| Target                       | What it does                                           |
| ---------------------------- | ------------------------------------------------------ |
| `make setup_nvim`            | Copy `nvim/` → `~/.config/nvim/` (no installs)         |
| `make setup_alacritty`       | Copy `alacritty/` → `~/.config/alacritty/`             |
| `make setup_zshrc`           | Copy `zsh/.zshrc` → `~/.zshrc`                         |
| `make install_nvim_deps_mac` | Install only the Homebrew deps Neovim needs            |
| `make install_nvim_mac`      | Full Neovim setup (deps + Neovim + config copy)        |
| `make install_nvim_debian`   | Source-build Neovim on Debian                          |
| `make reverse_nvim`          | Sync `~/.config/nvim/` back into `nvim/` (the inverse) |
| `make reverse_alacritty`     | Sync Alacritty config back                             |
| `make reverse_zshrc`         | Sync `.zshrc` back                                     |
| `make clean_nvim`            | Remove `~/.config/nvim/*`                              |
| `make status`                | Show current config paths                              |
| `make help`                  | List all targets                                       |

## Updating

After tweaking config in your live `~/.config/nvim`:

```sh
cd ~/programming/dotfiles
make reverse_nvim
git diff nvim/
git add nvim/ && git commit -m "<message>"
```

## Verifying nvim setup

```sh
# tree-sitter-cli on PATH?
nvim --headless -c "lua print(vim.fn.exepath('tree-sitter'))" -c "qa"
# Expected: /opt/homebrew/bin/tree-sitter (non-empty path)

# nvim-treesitter healthy?
nvim --headless -c "checkhealth nvim-treesitter" -c "qa" 2>&1 | head -40
```

## Troubleshooting

**`Error during "tree-sitter build": ENOENT ... 'tree-sitter'`**
The `tree-sitter` CLI isn't on PATH. Install `tree-sitter-cli` (not `tree-sitter`):

```sh
brew install tree-sitter-cli
```

**`attempt to call field 'install' (a nil value)` at startup**
nvim-treesitter is checked out on the old `master` branch but the config expects `main`. Force the branch switch:

```sh
nvim --headless "+Lazy! update nvim-treesitter nvim-treesitter-textobjects" +qa
```

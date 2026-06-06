#!/usr/bin/env bash
# Linux counterpart to the Brewfile. Detects apt / dnf / pacman and
# installs the same set of runtime deps Neovim + this dotfiles repo expect.
#
# Things that aren't reliably packaged across distros — tree-sitter CLI,
# the terminal emulators (kitty / alacritty / ghostty), and Nerd Fonts —
# get printed as TODO hints at the end instead of forced through a fragile
# package install.

set -euo pipefail

log()  { printf '\033[1;34m[linux-deps]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }

if command -v apt >/dev/null 2>&1; then
  PM=apt
  UPDATE="sudo apt update"
  INSTALL="sudo apt install -y"
  PKGS=(neovim ripgrep fd-find nodejs npm python3 python3-pip tmux build-essential curl git)
elif command -v dnf >/dev/null 2>&1; then
  PM=dnf
  UPDATE="sudo dnf check-update || true"
  INSTALL="sudo dnf install -y"
  PKGS=(neovim ripgrep fd-find nodejs npm python3 python3-pip tmux gcc make curl git)
elif command -v pacman >/dev/null 2>&1; then
  PM=pacman
  UPDATE="sudo pacman -Sy"
  INSTALL="sudo pacman -S --noconfirm --needed"
  PKGS=(neovim ripgrep fd nodejs npm python python-pip tmux base-devel curl git tree-sitter-cli)
else
  warn "no supported package manager found (apt/dnf/pacman). install deps manually."
  exit 1
fi

log "using $PM"
log "refreshing package index"
$UPDATE
log "installing: ${PKGS[*]}"
$INSTALL "${PKGS[@]}"

# Debian/Ubuntu names the binary fdfind. Most tools (and muscle memory)
# expect `fd`. Drop a shim into ~/.local/bin if there's no fd on PATH.
if [[ "$PM" == apt ]] && command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  log "linked fd -> fdfind in ~/.local/bin (Debian/Ubuntu naming workaround)"
fi

# tree-sitter CLI on apt/dnf is hit-or-miss. Pacman has it as a package.
if ! command -v tree-sitter >/dev/null; then
  warn "tree-sitter CLI not on PATH. nvim-treesitter needs it to compile parsers."
  echo "    npm install -g tree-sitter-cli"
  echo "    # or:  cargo install tree-sitter-cli"
fi

# rustup: distros ship it but the upstream installer is the canonical path.
if ! command -v rustup >/dev/null && ! command -v cargo >/dev/null; then
  warn "rust toolchain missing. install with:"
  echo "    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi

cat <<'EOF'

Not handled automatically (distro-specific):
  - kitty / alacritty / ghostty: install from your package manager or
    the vendor's instructions. ghostty isn't widely packaged yet.
  - Nerd Fonts: download a release from
    https://github.com/ryanoasis/nerd-fonts/releases
    drop into ~/.local/share/fonts/, then run: fc-cache -fv
EOF

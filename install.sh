#!/usr/bin/env bash
# Symlink-based installer for this dotfiles repo.
#
# What it does:
#   - For each package in ~/.config (nvim, alacritty, ghostty, kitty),
#     back up an existing real directory to <name>.backup.<timestamp>,
#     then symlink it into this repo.
#   - Same idea for ~/.zshrc and ~/.tmux.conf.
#   - Runs `brew bundle` if a Brewfile is present and Homebrew is installed.
#
# Re-running is safe. If a path is already a symlink into this repo,
# it's left alone.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }

# Symlink $REPO_DIR/$src to $HOME/$dest. If $dest exists and is not
# already a symlink into the repo, move it to <dest>.backup.<ts>.
link() {
  local src="$1" dest="$2"
  local src_abs="$REPO_DIR/$src"
  local dest_abs="$HOME/$dest"

  if [[ ! -e "$src_abs" ]]; then
    warn "skipping $src — not in repo"
    return
  fi

  if [[ -L "$dest_abs" ]]; then
    local current
    current="$(readlink "$dest_abs")"
    if [[ "$current" == "$src_abs" ]]; then
      log "$dest already linked"
      return
    fi
    warn "$dest is a symlink to $current — replacing"
    rm "$dest_abs"
  elif [[ -e "$dest_abs" ]]; then
    local backup="${dest_abs}.backup.${TS}"
    warn "$dest exists, backing up to $(basename "$backup")"
    mv "$dest_abs" "$backup"
  fi

  mkdir -p "$(dirname "$dest_abs")"
  ln -s "$src_abs" "$dest_abs"
  log "linked $dest -> $src"
}

log "repo root: $REPO_DIR"

# ~/.config packages
link nvim       .config/nvim
link alacritty  .config/alacritty
link ghostty    .config/ghostty
link kitty      .config/kitty

# Home-level files
link zsh/.zshrc           .zshrc
link tmux-conf/.tmux.conf.local .tmux.conf.local

# Platform-specific dependency install
case "$(uname -s)" in
  Darwin)
    if [[ -f "$REPO_DIR/Brewfile" ]]; then
      if command -v brew >/dev/null 2>&1; then
        log "running brew bundle"
        brew bundle --file="$REPO_DIR/Brewfile"
      else
        warn "Brewfile present but brew not found — install Homebrew first: https://brew.sh"
      fi
    fi
    ;;
  Linux)
    if [[ -x "$REPO_DIR/linux-deps.sh" ]]; then
      log "running linux-deps.sh"
      "$REPO_DIR/linux-deps.sh"
    else
      warn "linux-deps.sh missing or not executable; skipping dep install"
    fi
    ;;
  *)
    warn "unsupported OS $(uname -s); install deps manually"
    ;;
esac

cat <<'EOF'

Done. Next steps:
  1. Open nvim once. lazy.nvim will install plugins from lazy-lock.json,
     mason will install LSP servers, and nvim-treesitter will compile
     parsers (requires tree-sitter-cli, in the Brewfile).
  2. If you edited anything in ~/.config/<pkg> before today, your old
     files are saved as ~/.config/<pkg>.backup.<timestamp>.
EOF

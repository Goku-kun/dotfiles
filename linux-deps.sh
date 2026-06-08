#!/usr/bin/env bash
# Linux counterpart to the Brewfile.
#
# Goal: on a fresh Debian/Ubuntu, Fedora, or Arch box, end up with
# Neovim >= 0.12 and the toolchain this dotfiles repo expects (ripgrep,
# fd, node, npm, python3, tmux, rustup, tree-sitter CLI, build tools).
#
# Install sources are chosen per the upstream-recommended path for each
# tool, not whatever the distro happens to ship:
#   - Neovim:        official tarball -> /opt, symlinked into /usr/local/bin
#                    (apt's `neovim` package is ancient, ~0.7.x on stable).
#                    Skipped on Arch (pacman tracks upstream).
#   - ripgrep, fd:   distro package (Arch's `fd` ships the right binary;
#                    apt/dnf's `fd-find` gets a ~/.local/bin/fd shim).
#   - node + npm:    distro package (good enough as a baseline; install
#                    nvm yourself if you want per-project node versions).
#   - tree-sitter:   pacman package on Arch, `npm -g` elsewhere.
#   - rustup:        upstream installer (sh.rustup.rs).
#
# Not installed: nvm, terminal emulators (kitty/alacritty/ghostty),
# Nerd Fonts. Hints printed at the end.
#
# Re-running is safe — every step guards on `command -v` or a version check.

set -euo pipefail

log()  { printf '\033[1;34m[linux-deps]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

PM=""

detect_pm() {
  if command -v apt >/dev/null 2>&1;    then PM=apt
  elif command -v dnf >/dev/null 2>&1;  then PM=dnf
  elif command -v pacman >/dev/null 2>&1; then PM=pacman
  else die "no supported package manager found (apt/dnf/pacman)"
  fi
  log "package manager: $PM"
}

install_distro_packages() {
  local pkgs update install
  case "$PM" in
    apt)
      update="sudo apt update"
      install="sudo apt install -y"
      # libclang-dev + pkg-config are needed by bindgen (used by rquickjs,
      # a transitive dep of tree-sitter-cli) when building via cargo.
      pkgs=(ripgrep fd-find nodejs npm python3 python3-pip tmux build-essential libclang-dev pkg-config curl git xz-utils ca-certificates)
      ;;
    dnf)
      update="sudo dnf check-update || true"
      install="sudo dnf install -y"
      pkgs=(ripgrep fd-find nodejs npm python3 python3-pip tmux gcc make clang-devel pkgconfig curl git xz ca-certificates)
      ;;
    pacman)
      update="sudo pacman -Sy"
      install="sudo pacman -S --noconfirm --needed"
      # Arch's neovim and tree-sitter-cli are current; install here.
      pkgs=(neovim tree-sitter-cli ripgrep fd nodejs npm python python-pip tmux base-devel clang pkgconf curl git ca-certificates)
      ;;
  esac

  log "refreshing package index"
  $update
  log "installing: ${pkgs[*]}"
  $install "${pkgs[@]}"
}

# Has a Neovim with major.minor >= 0.12 already on PATH?
have_modern_nvim() {
  command -v nvim >/dev/null 2>&1 || return 1
  local v major minor
  v=$(nvim --version | head -1 | awk '{print $2}' | sed 's/^v//')
  major=${v%%.*}
  minor=${v#*.}; minor=${minor%%.*}
  if (( major > 0 )) || { (( major == 0 )) && (( minor >= 12 )); }; then
    log "nvim $v already on PATH; skipping tarball install"
    return 0
  fi
  log "found nvim $v; config needs >= 0.12, replacing"
  return 1
}

install_neovim_tarball() {
  have_modern_nvim && return 0

  local arch artifact
  case "$(uname -m)" in
    x86_64)        arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *)
      warn "unsupported arch $(uname -m) for prebuilt nvim — build from source:"
      echo "    https://github.com/neovim/neovim/blob/master/BUILD.md"
      return 1
      ;;
  esac
  artifact="nvim-linux-${arch}.tar.gz"

  local tmp
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' RETURN

  log "downloading $artifact from neovim/neovim releases"
  curl -fL --proto '=https' --tlsv1.2 -o "$tmp/$artifact" \
    "https://github.com/neovim/neovim/releases/latest/download/$artifact"
  tar -xzf "$tmp/$artifact" -C "$tmp"

  # Official path: extract under /opt, then link the binary into /usr/local/bin.
  # /usr/local/bin precedes /usr/bin in default PATH, so this shadows any
  # apt-installed nvim with zero shell-rc edits.
  sudo rm -rf "/opt/nvim-linux-${arch}"
  sudo mv "$tmp/nvim-linux-${arch}" /opt/
  sudo ln -sf "/opt/nvim-linux-${arch}/bin/nvim" /usr/local/bin/nvim

  log "installed: $(/usr/local/bin/nvim --version | head -1)"
}

# apt and Fedora package fd as `fdfind` because Debian has a conflicting
# `fd` package. Drop a ~/.local/bin/fd shim so muscle memory + telescope
# both work.
install_fd_shim() {
  [[ "$PM" == pacman ]] && return 0
  command -v fdfind >/dev/null 2>&1 || return 0
  command -v fd >/dev/null 2>&1 && return 0

  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  log "linked ~/.local/bin/fd -> $(command -v fdfind)"

  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) warn "~/.local/bin is not on PATH. Add this to your shell rc:"
       echo '    export PATH="$HOME/.local/bin:$PATH"' ;;
  esac
}

install_rustup() {
  if command -v rustup >/dev/null 2>&1 || command -v cargo >/dev/null 2>&1; then
    log "rust toolchain already present; skipping rustup"
    return 0
  fi
  log "installing rustup via upstream installer"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
}

install_nvm() {
  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    log "nvm already installed at ~/.nvm; skipping installer"
  else
    log "installing nvm v0.40.4"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
  fi

  # Load nvm into this shell so subsequent steps can call it. The installer
  # has already appended source lines to ~/.bashrc / ~/.zshrc for future shells.
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"

  if command -v nvm >/dev/null 2>&1; then
    log "installing latest LTS node via nvm"
    nvm install --lts
    nvm use --lts >/dev/null
  else
    warn "nvm not on PATH after install — open a new shell and re-run if Node is missing"
  fi
}

install_tree_sitter_cli() {
  [[ "$PM" == pacman ]] && return 0   # arch installs via pacman above
  if command -v tree-sitter >/dev/null 2>&1; then
    log "tree-sitter CLI already on PATH; skipping"
    return 0
  fi

  # Prefer cargo: builds against local glibc and avoids the prebuilt-binary
  # GLIBC_2.39 mismatch that `npm install -g tree-sitter-cli` hits on
  # Debian 12 / Ubuntu 22.04. libclang-dev (installed earlier) covers the
  # bindgen build for the rquickjs transitive dep.
  if command -v cargo >/dev/null 2>&1; then
    log "installing tree-sitter-cli via cargo (builds from source)"
    cargo install tree-sitter-cli
    return 0
  fi

  if command -v npm >/dev/null 2>&1; then
    warn "cargo not on PATH; falling back to npm. The npm prebuilt binary"
    warn "requires GLIBC 2.39+ and may fail on Debian 12 / Ubuntu 22.04."
    sudo npm install -g tree-sitter-cli
    return 0
  fi

  warn "neither cargo nor npm available; install tree-sitter-cli manually"
  return 1
}

print_hints() {
  cat <<'EOF'

Not installed automatically (intentional):
  - Terminal emulators (kitty / alacritty / ghostty). Distro coverage
    is uneven, especially ghostty. Install via your package manager
    or vendor instructions.
  - Nerd Fonts. Download a release from
      https://github.com/ryanoasis/nerd-fonts/releases
    Extract into ~/.local/share/fonts/, then: fc-cache -fv

Verify:
  nvim --version | head -1     # expect v0.12.x or newer
  rg --version
  fd --version
  tree-sitter --version
  cargo --version
  node --version
  tmux -V
EOF
}

main() {
  detect_pm
  install_distro_packages
  install_neovim_tarball
  install_fd_shim
  install_rustup
  install_nvm
  install_tree_sitter_cli
  print_hints
}

main "$@"

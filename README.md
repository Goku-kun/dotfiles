# dotfiles

Symlinks `~/.config/<pkg>` dirs, `~/.zshrc`, and `~/.tmux.conf.local` to this repo. `./install.sh` to set up a new machine.

## What's in here

| Path                         | Linked to             |
| ---------------------------- | --------------------- |
| `nvim/`                      | `~/.config/nvim`      |
| `alacritty/`                 | `~/.config/alacritty` |
| `ghostty/`                   | `~/.config/ghostty`   |
| `kitty/`                     | `~/.config/kitty`     |
| `zsh/.zshrc`                 | `~/.zshrc`            |
| `tmux-conf/.tmux.conf.local` | `~/.tmux.conf.local`  |

`install.sh` also clones gpakosz [Oh my tmux!](https://github.com/gpakosz/.tmux) into `~/.tmux` and links `~/.tmux.conf` to it. That upstream isn't tracked here, only `tmux-conf/.tmux.conf.local` (my customizations) is.

Plus `Brewfile` (macOS deps), `linux-deps.sh` (apt/dnf/pacman deps), `install.sh`, and `legacy/` (old configs I keep around but don't install).

## Quick start

    git clone <repo-url> ~/programming/dotfiles
    cd ~/programming/dotfiles
    ./install.sh

The script moves any existing real `~/.config/<pkg>` to `~/.config/<pkg>.backup.<timestamp>`, symlinks it back into this repo, then installs deps based on the OS:

- **macOS:** `brew bundle` against `Brewfile`.
- **Linux:** `linux-deps.sh`, which detects apt / dnf / pacman and installs equivalents. Terminal emulators and Nerd Fonts aren't reliably packaged across distros, so it prints hints for those rather than guessing.

Safe to re-run; paths already pointing at the repo are skipped.

## Secrets

`zsh/.zshrc` keeps placeholders like `OLLAMA_API_KEY=ENTER_KEY_HERE`. Put the real values in `~/.zshrc.local` (not tracked, sourced at the bottom of the tracked `.zshrc`):

    echo 'export OLLAMA_API_KEY=...' >> ~/.zshrc.local
    chmod 600 ~/.zshrc.local

## Fonts

The terminal font (Dank Mono, patched so kitty's monospace matcher accepts it and with a heavier bold) lives in a separate private repo, since it's a paid font that can't be published here:

    git clone git@github.com:Goku-kun/dotfiles-fonts.git
    cd dotfiles-fonts && ./install.sh

## After install

Open `nvim` once. lazy.nvim pulls plugins from `nvim/lazy-lock.json`, mason fetches LSP servers, nvim-treesitter compiles parsers (needs `tree-sitter` on PATH, which the Brewfile installs).

Start `tmux` once. gpakosz's config auto-installs tpm and the plugins listed in `.tmux.conf.local` (copycat, cpu, resurrect, continuum) on first launch. To update the upstream later: `git -C ~/.tmux pull`.

## Editing config

Edit `~/.config/<pkg>/...` normally. Because the dir is a symlink, the change shows up in this repo:

    cd ~/programming/dotfiles
    git status
    git add . && git commit -m "<message>"

## Prerequisites

- Neovim 0.12+ (uses nvim-treesitter `main` branch). Installed by `Brewfile`.
- Xcode CLI tools on macOS: `xcode-select --install`.
- Homebrew: <https://brew.sh>.

## Verifying nvim

    nvim --headless -c "lua print(vim.fn.exepath('tree-sitter'))" -c "qa"
    nvim --headless -c "checkhealth nvim-treesitter" -c "qa" 2>&1 | head -40

## Troubleshooting

`Error during "tree-sitter build": ENOENT` — tree-sitter isn't on PATH. `brew install tree-sitter`.

`attempt to call field 'install' (a nil value)` — nvim-treesitter is on the old `master` branch. Force the switch: `nvim --headless "+Lazy! update nvim-treesitter nvim-treesitter-textobjects" +qa`.

## Restoring a backup

Old config sits at `~/.config/<pkg>.backup.<timestamp>`:

    rm ~/.config/nvim
    mv ~/.config/nvim.backup.<ts> ~/.config/nvim

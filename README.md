# mdots

Personal dotfiles for a macOS dev environment.

Companion to [dotfiles](https://github.com/YannickHerrero/dotfiles) (the Debian
13 VPS variant) — same tools, same configs, same terminal experience.

## Quick Start

```bash
git clone https://github.com/YannickHerrero/mdots.git ~/dev/mdots
cd ~/dev/mdots
./install.sh all
```

Requires `sudo` access (used by the `zsh` module to register brew's zsh in
`/etc/shells`, and by the `tools` module to install `colorscript`), Xcode
Command Line Tools (auto-installed by the `brew` module on first run), and
an internet connection.

Runs on macOS's stock `/bin/bash` (3.2) — no `brew install bash` prereq.

## Modular Installation

Install specific components:

```bash
./install.sh brew       # Homebrew + system deps (curl, ripgrep, fzf, bat, eza, ...)
./install.sh zsh        # Zsh (brew) + oh-my-posh
./install.sh tmux       # Tmux
./install.sh nvim       # Neovim (brew)
./install.sh mise       # mise runtime manager
./install.sh node       # Node.js LTS + bun + pnpm + npm packages
./install.sh rust       # Rust toolchain (rustup)
./install.sh tools      # zoxide, delta, lazygit, gh, macchina, ...
./install.sh aerospace  # AeroSpace tiling window manager (mirrors glazewm bindings)
./install.sh wezterm    # WezTerm terminal emulator + JetBrainsMono Nerd Font
./install.sh firefox    # Firefox + userChrome.css UI customization + Cozette font
./install.sh claude     # Claude Code global config + skills
./install.sh ssh        # Optional GitHub SSH key generation
./install.sh git        # Git configuration
./install.sh dotfiles   # Copy all config files
```

Or combine:

```bash
./install.sh brew zsh nvim
```

Tmux and oh-my-posh intentionally inherit colors from the terminal emulator
so the same theme renders identically on macOS and on the Debian VPS.

GitHub SSH setup is optional. Public bootstrap downloads use HTTPS by default
so a fresh shell works before adding a GitHub SSH key.

The `git` module reuses an existing global Git identity when `user.name` and
`user.email` are already set, and asks for confirmation before keeping them.

The `claude` module installs user-scoped Claude Code configuration into
`~/.claude/`. The default settings disable Claude attribution in commits and
pull requests, allow common Git workflows without prompts, ask for approval
on higher-risk commands, and block a few dangerous patterns outright.

## What's Included

### Tools Installed

#### Shell & Terminal

| Tool | Installation | Description |
|------|--------------|-------------|
| zsh | brew | Shell with zinit plugin manager (newer than macOS's stock zsh) |
| oh-my-posh | curl | Prompt that inherits terminal colors |
| tmux | brew | Terminal multiplexer with TPM |
| wezterm | brew cask | GPU-accelerated terminal; config ported from windot (`~/.wezterm.lua`) |

#### Desktop / WM

| Tool | Installation | Description |
|------|--------------|-------------|
| AeroSpace | brew cask | i3-like tiling window manager. Config at `~/.config/aerospace/aerospace.toml` mirrors the [glazewm](https://github.com/YannickHerrero/windot) bindings exactly (Alt+hjkl focus, Alt+Shift+hjkl move, Alt+1..9 workspaces, etc). Needs Accessibility permission on first launch. |
| Firefox | brew cask | Browser with `userChrome.css` UI debloating (auto-hide tabs/navbar, compact controls). Profile customization is auto-deployed by `./install.sh firefox` once Firefox has created its default profile. |

#### Editor

| Tool | Installation | Description |
|------|--------------|-------------|
| neovim | brew | Text editor (0.11+) |

#### Runtime Managers / Toolchains

| Tool | Installation | Description |
|------|--------------|-------------|
| mise | curl | Polyglot runtime manager |
| rustup | curl | Rust toolchain installer (provides cargo, rustc, rustfmt, clippy) |

#### JavaScript

| Tool | Installation | Description |
|------|--------------|-------------|
| Node.js LTS | mise | JavaScript runtime |
| bun | mise | JavaScript runtime/bundler |
| pnpm | mise | Fast package manager |
| eas-cli | npm | Expo Application Services |
| tree-sitter-cli | npm | Parser builder for nvim-treesitter v1 |

#### CLI Tools

| Tool | Installation | Description |
|------|--------------|-------------|
| claude code | curl | AI coding assistant |
| zoxide | mise | Smart cd |
| delta | mise | Git diff viewer |
| lazygit | mise | Git TUI |
| gh | mise | GitHub CLI |
| gh-notify | gh ext | GitHub notifications inbox (used by snacks dashboard) |
| colorscript | git/make | shell-color-scripts; decorative blocks in snacks dashboard |
| macchina | cargo | Rust-based system info fetch (aliased to `fetch`) |
| fzf | brew | Fuzzy finder |
| eza | brew | Modern ls |
| bat | brew | Cat with syntax highlighting |
| ripgrep | brew | Fast grep |
| fd | brew | Fast find |

### Neovim Plugins

| Plugin | Role |
|--------|------|
| lazy.nvim | Plugin manager |
| blink.cmp | Completion (Rust-backed) |
| snacks.nvim | picker, explorer, dashboard, bigfile, quickfile |
| mini.nvim | pairs, surround, statusline, tabline, icons |
| nvim-treesitter (v1 main) | Syntax highlighting + indent |
| nvim-lspconfig + mason + mason-lspconfig | LSP wiring |
| mason-tool-installer | Auto-installs stylua / prettier / shfmt |
| conform.nvim | Format-on-save |
| which-key.nvim | Keybinding hints |
| nvim-tmux-navigation | C-h/j/k/l between nvim and tmux panes |

**LSP servers** (auto-installed via mason): `ts_ls`, `rust_analyzer`, `lua_ls`, `bashls`.
**Formatters** (auto-installed via mason-tool-installer): `stylua`, `prettier`, `shfmt`. `rustfmt` comes from the Rust toolchain.

### Key Bindings

#### Tmux (prefix: Ctrl+A)
| Key | Action |
|-----|--------|
| `prefix + \|` | Split vertical |
| `prefix + -` | Split horizontal |
| `prefix + r` | Reload config |
| `Ctrl + h/j/k/l` | Navigate panes |
| `Alt + 1-5` | Switch windows |

#### Neovim (leader: Space)
| Key | Action |
|-----|--------|
| `Space + Space` | Find files (snacks.picker) |
| `Space + sg` | Live grep (snacks.picker) |
| `Space + e` | Toggle file explorer (snacks.explorer, right-side) |
| `Space + bd` | Close buffer |
| `Space + o` | Toggle statusline visibility |
| `Shift + h/l` | Previous/next buffer (also switches tab in mini.tabline) |
| `gd` | Go to definition (LSP) |
| `gr` | Find references (LSP) |
| `K` | Hover docs (LSP) |
| `Space + ca` | Code action (LSP) |
| `Space + rn` | Rename symbol (LSP) |

#### Zsh
| Key | Action |
|-----|--------|
| `f` | Tmux sessionizer (select project, create/attach session) |
| `ff` | Fuzzy find files, open in nvim |
| `z <dir>` | Smart cd with zoxide |

## Directory Structure

```
mdots/
├── install.sh              # Main install script
├── config/
│   ├── git/.gitconfig
│   ├── claude/             # Claude Code global config and skills
│   ├── nvim/               # Neovim config
│   ├── ohmyposh/zen.toml   # Prompt theme
│   ├── tmux/tmux.conf
│   └── zsh/                # Zsh configs
├── scripts/
│   └── modules/            # Install modules
```

## Troubleshooting

If an install step dies partway through (network blip, transient brew failure,
etc.), it's safe to just re-run:

```bash
./install.sh all          # picks up where it left off
./install.sh <module>     # or re-run a single module
```

Every module is idempotent — already-installed tools are detected via
`command -v` and skipped, and `./install.sh dotfiles` sweeps stale
configs before copying so removing a plugin upstream actually
removes it from `~/.config/nvim`.

`gh auth login` is interactive and must be run manually; the
`gh-notify` extension install in `tools.sh` is skipped (with an
explanatory message) until then. Re-run `./install.sh tools` after
authenticating.

On Apple Silicon, Homebrew installs to `/opt/homebrew`; on Intel Macs to
`/usr/local`. The `.zshrc` handles both — no manual PATH tweaks required.

## Requirements

- macOS (Apple Silicon or Intel)
- Xcode Command Line Tools (`xcode-select --install`)
- sudo access
- Internet connection

## Differences from the Linux dotfiles

The end-user experience is identical, but the implementation diverges where
necessary:

- Packages installed via `brew` instead of `apt`
- `ls -G` (BSD) instead of `ls --color` (GNU)
- `bat` directly (brew name) instead of `batcat` (Debian rename)
- `stat -f %m` (BSD) instead of `stat -c %Y` (GNU) in the Claude statusline
- `find ... -exec basename {} \;` instead of GNU `find -printf '%f\n'` in the
  tmux sessionizer
- Homebrew shellenv prepended to PATH instead of `/snap/bin`
- Neovim via `brew install neovim` instead of the GitHub tarball

## License

MIT

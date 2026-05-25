#!/bin/bash
set -euo pipefail
# Copy all dotfiles to their appropriate locations

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

copy_dotfiles() {
    echo "Copying dotfiles..."

    # Create necessary directories
    mkdir -p "$HOME/.config/nvim/lua/plugins"
    mkdir -p "$HOME/.config/ohmyposh"
    mkdir -p "$HOME/.config/tmux"
    mkdir -p "$HOME/.config/zsh"
    mkdir -p "$HOME/dev"

    # Copy nvim config
    echo "  - Neovim config"
    cp "$DOTFILES_DIR/config/nvim/init.lua" "$HOME/.config/nvim/"
    cp "$DOTFILES_DIR/config/nvim/stylua.toml" "$HOME/.config/nvim/"
    cp "$DOTFILES_DIR/config/nvim/lua/vim-options.lua" "$HOME/.config/nvim/lua/"
    # Mirror the repo's plugin directory: drop stale specs that were removed
    # upstream before copying so lazy.nvim doesn't keep loading them.
    rm -f "$HOME/.config/nvim/lua/plugins/"*.lua
    cp "$DOTFILES_DIR/config/nvim/lua/plugins/"*.lua "$HOME/.config/nvim/lua/plugins/"
    rm -f "$HOME/.config/nvim/lua/plugins.lua"

    # Copy zsh config under XDG_CONFIG_HOME/zsh; ~/.zshenv points zsh there.
    echo "  - Zsh config"
    cp "$DOTFILES_DIR/config/zsh/.zshenv" "$HOME/.zshenv"
    cp "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"
    cp "$DOTFILES_DIR/config/zsh/"*.zsh "$HOME/.config/zsh/"
    # Clean up any leftovers from the pre-XDG layout.
    rm -f "$HOME/.zshrc"
    rm -rf "$HOME/.zsh"

    # Copy tmux config
    echo "  - Tmux config"
    cp "$DOTFILES_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

    # Copy oh-my-posh config
    echo "  - Oh My Posh config"
    cp "$DOTFILES_DIR/config/ohmyposh/zen.toml" "$HOME/.config/ohmyposh/"

    echo "Dotfiles copied!"
}

copy_dotfiles

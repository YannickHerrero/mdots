#!/bin/bash
set -euo pipefail
# Install WezTerm and the Nerd Font it expects, then deploy config.

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

install_wezterm() {
    echo "Installing WezTerm..."

    if ! command -v brew &> /dev/null; then
        echo "Error: brew is not installed. Please run brew.sh first."
        exit 1
    fi

    if ! brew list --cask wezterm &> /dev/null; then
        if [[ -d /Applications/WezTerm.app ]]; then
            # Existing manual install — let brew take over instead of failing.
            brew install --cask --adopt wezterm
        else
            brew install --cask wezterm
        fi
    else
        echo "WezTerm already installed"
    fi

    if ! brew list --cask font-jetbrains-mono-nerd-font &> /dev/null; then
        brew install --cask font-jetbrains-mono-nerd-font
    else
        echo "JetBrainsMono Nerd Font already installed"
    fi

    # WezTerm looks for ~/.wezterm.lua first; mirror windot's path.
    cp "$DOTFILES_DIR/config/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"
    echo "Config installed: ~/.wezterm.lua"
}

install_wezterm

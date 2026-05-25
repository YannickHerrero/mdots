#!/bin/bash
set -euo pipefail
# Install AeroSpace (macOS tiling WM) and deploy its config.

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

install_aerospace() {
    echo "Installing AeroSpace..."

    if ! command -v brew &> /dev/null; then
        echo "Error: brew is not installed. Please run brew.sh first."
        exit 1
    fi

    if ! brew list --cask aerospace &> /dev/null; then
        brew install --cask nikitabobko/tap/aerospace
    else
        echo "AeroSpace already installed"
    fi

    # Deploy config
    mkdir -p "$HOME/.config/aerospace"
    cp "$DOTFILES_DIR/config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
    echo "Config installed: ~/.config/aerospace/aerospace.toml"

    add_notice "AeroSpace needs Accessibility permission: System Settings → Privacy & Security → Accessibility → enable AeroSpace. Then launch /Applications/AeroSpace.app."
}

install_aerospace

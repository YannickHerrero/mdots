#!/bin/bash
set -euo pipefail
# Install wbar (minimalist status bar for GlazeWM, cross-platform with the
# windot config) and deploy its TOML config. Builds from source via
# `cargo install --git`; no published release binary is needed.

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

install_wbar() {
    echo "Installing wbar..."

    if ! command -v cargo &>/dev/null; then
        echo "Error: cargo is not installed. Please run './install.sh rust' first."
        exit 1
    fi

    if ! command -v wbar &>/dev/null; then
        echo "Building wbar from source (compiles eframe + deps, ~1-2 minutes)..."
        cargo install --locked --git https://github.com/yannickherrero/wbar.git
    else
        echo "wbar already installed"
    fi

    # wbar reads ~/Library/Application Support/wbar/config.toml on macOS
    # (resolved via the `dirs` crate's config_dir).
    mkdir -p "$HOME/Library/Application Support/wbar"
    cp "$DOTFILES_DIR/config/wbar/config.toml" "$HOME/Library/Application Support/wbar/config.toml"
    echo "Config installed: ~/Library/Application Support/wbar/config.toml"

    add_notice "wbar: launch with 'wbar' from a terminal (it runs as a menu-bar accessory, no Dock tile). To auto-start at login, add it to System Settings → General → Login Items, or write a LaunchAgent."
}

install_wbar

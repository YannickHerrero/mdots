#!/bin/bash
set -euo pipefail
# Install GlazeWM (cross-platform tiling WM) and deploy its config.
# GlazeWM has its own tray-menu auto-start toggle ("Run on system startup"),
# so no LaunchAgent is needed.

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

install_glazewm() {
    echo "Installing GlazeWM..."

    if ! command -v brew &> /dev/null; then
        echo "Error: brew is not installed. Please run brew.sh first."
        exit 1
    fi

    if ! brew list --cask glazewm &> /dev/null; then
        brew install --cask glzr-io/tap/glazewm
    else
        echo "GlazeWM already installed"
    fi

    # GlazeWM expects ~/.glzr/glazewm/config.yaml (Windows convention ported);
    # mirrors the windot layout so behavior matches across OSes.
    mkdir -p "$HOME/.glzr/glazewm"
    cp "$DOTFILES_DIR/config/glazewm/config.yaml" "$HOME/.glzr/glazewm/config.yaml"
    echo "Config installed: ~/.glzr/glazewm/config.yaml"

    add_notice "GlazeWM needs Accessibility permission: System Settings → Privacy & Security → Accessibility → enable GlazeWM. Then launch /Applications/GlazeWM.app."
    add_notice "GlazeWM and AeroSpace must NOT run simultaneously. Quit AeroSpace via its menu-bar icon before launching GlazeWM. Auto-start is toggled via GlazeWM's tray menu — leave it off until you've decided which WM to keep."
}

install_glazewm

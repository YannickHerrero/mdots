#!/bin/bash
set -euo pipefail
# Install Neovim (latest stable) via Homebrew

install_nvim() {
    echo "Installing Neovim via Homebrew..."

    if ! command -v brew &> /dev/null; then
        echo "Error: brew is not installed. Please run brew.sh first."
        exit 1
    fi

    if ! brew list neovim &> /dev/null; then
        brew install neovim
    else
        echo "Neovim already installed; checking for upgrade..."
        brew upgrade neovim || true
    fi

    echo "Neovim $(nvim --version | head -1) installed!"
}

install_nvim

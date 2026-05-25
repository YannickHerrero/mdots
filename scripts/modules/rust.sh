#!/bin/bash
set -euo pipefail
# Install the Rust toolchain via rustup.

install_rust() {
    echo "Installing Rust toolchain..."

    if command -v cargo &> /dev/null; then
        echo "Rust already installed: $(rustc --version 2>/dev/null || echo 'unknown')"
        return 0
    fi

    # rustup is the official installer. --no-modify-path keeps it from
    # writing to ~/.bashrc / ~/.zshrc; PATH is managed in config/zsh/.zshrc
    # by the dotfiles directly.
    local installer
    installer="$(mktemp)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o "$installer"
    sh "$installer" -y --no-modify-path
    rm -f "$installer"

    # Make cargo / rustc available for the rest of this install session so
    # subsequent modules (e.g. tools.sh's macchina install) can use them.
    export PATH="$HOME/.cargo/bin:$PATH"

    echo "Rust installed: $(rustc --version)"
}

install_rust

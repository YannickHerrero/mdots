#!/bin/bash
set -euo pipefail
# Install zsh and oh-my-posh

install_zsh() {
    echo "Installing zsh..."

    # macOS ships zsh, but brew's version is newer and matches the Linux
    # apt-installed zsh feature set. Install/upgrade via brew.
    if ! brew list zsh &> /dev/null; then
        brew install zsh
    else
        echo "brew zsh already installed"
    fi

    local brew_zsh
    brew_zsh="$(brew --prefix)/bin/zsh"

    # Allow brew's zsh as a login shell, then make it the default.
    if ! grep -qx "$brew_zsh" /etc/shells; then
        echo "Adding $brew_zsh to /etc/shells (sudo)..."
        echo "$brew_zsh" | sudo tee -a /etc/shells > /dev/null
    fi

    if [[ "$SHELL" != "$brew_zsh" ]]; then
        echo "Setting brew zsh as default shell..."
        chsh -s "$brew_zsh"
    else
        echo "brew zsh is already the default shell"
    fi

    echo "Installing oh-my-posh..."

    if ! command -v oh-my-posh &> /dev/null; then
        local installer
        installer="$(mktemp)"
        curl -fsSL https://ohmyposh.dev/install.sh -o "$installer"
        bash "$installer"
        rm -f "$installer"
    else
        echo "oh-my-posh already installed"
    fi

    echo "Zsh and oh-my-posh installed!"
}

install_zsh

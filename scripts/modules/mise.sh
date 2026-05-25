#!/bin/bash
set -euo pipefail
# Install mise - polyglot runtime manager

install_mise() {
    echo "Installing mise..."

    if ! command -v mise &> /dev/null; then
        local installer
        installer="$(mktemp)"
        curl -fsSL https://mise.run -o "$installer"
        sh "$installer"
        rm -f "$installer"
    else
        echo "mise already installed"
    fi

    # Add mise to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"

    echo "mise installed!"
}

install_mise

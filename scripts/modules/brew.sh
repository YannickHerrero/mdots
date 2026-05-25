#!/bin/bash
set -euo pipefail
# Install Homebrew and system dependencies

install_brew() {
    echo "Installing Homebrew and system dependencies..."

    # Xcode Command Line Tools provide compilers, make, git, etc.
    if ! xcode-select -p &> /dev/null; then
        echo "Installing Xcode Command Line Tools (interactive prompt)..."
        xcode-select --install || true
        add_notice "Re-run './install.sh brew' after Xcode Command Line Tools finish installing."
        return 0
    fi

    # Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed"
    fi

    # Make brew available for the rest of this install session
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    brew update

    brew install \
        bash \
        curl \
        wget \
        unzip \
        git \
        mosh \
        ripgrep \
        fd \
        fzf \
        bat \
        eza \
        python@3.12

    echo "System dependencies installed!"
}

install_brew

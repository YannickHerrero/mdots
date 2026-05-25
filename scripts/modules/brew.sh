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

    # Source brew shellenv first — brew may already be installed but missing
    # from PATH (e.g. after wiping .zprofile / .zshrc for a clean install).
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Newly-installed brew needs its shellenv loaded too
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "Homebrew already installed"
    fi

    # Don't abort the install if a stale/removed tap makes `brew update`
    # exit non-zero — `brew install` works fine off the current formula cache.
    brew update || echo "brew update reported issues (continuing)"

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

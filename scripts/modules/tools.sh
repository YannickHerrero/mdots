#!/bin/bash
set -euo pipefail
# Install additional CLI tools

install_tools() {
    echo "Installing additional tools..."

    # Check if mise is installed
    if ! command -v mise &> /dev/null; then
        echo "Error: mise is not installed. Please run mise.sh first."
        exit 1
    fi

    # Ensure mise is in PATH
    export PATH="$HOME/.local/bin:$PATH"

    # Install Claude Code
    if ! command -v claude &> /dev/null; then
        echo "Installing Claude Code..."
        local installer
        installer="$(mktemp)"
        curl -fsSL https://claude.ai/install.sh -o "$installer"
        bash "$installer"
        rm -f "$installer"
    else
        echo "Claude Code already installed"
    fi

    # Install zoxide
    echo "Installing zoxide..."
    mise use --global zoxide@latest

    # Install delta (git diff tool)
    echo "Installing delta..."
    mise use --global delta@latest

    # Install lazygit
    echo "Installing lazygit..."
    mise use --global lazygit@latest

    # Install macchina (Rust-based system info fetch, aliased to `fetch`).
    # mise's registry doesn't include macchina; build from source via cargo.
    if ! command -v macchina &>/dev/null; then
        if command -v cargo &>/dev/null; then
            echo "Installing macchina (compiles from source, ~1 minute)..."
            cargo install --locked macchina
        else
            echo "Skipping macchina: cargo not found."
            echo "  Install Rust (https://rustup.rs), then re-run './install.sh tools'."
        fi
    else
        echo "macchina already installed"
    fi

    # Install GitHub CLI (used by snacks.dashboard GitHub sections)
    echo "Installing GitHub CLI..."
    mise use --global gh@latest

    # Install gh-notify extension (powers the snacks.dashboard Notifications section).
    # Requires gh to be authenticated — `gh extension list` errors otherwise.
    if mise exec -- gh auth status &>/dev/null; then
        if ! mise exec -- gh extension list | grep -q "meiji163/gh-notify"; then
            echo "Installing gh-notify extension..."
            mise exec -- gh extension install meiji163/gh-notify
        else
            echo "gh-notify extension already installed"
        fi
    else
        echo "Skipping gh-notify extension: gh CLI not authenticated yet."
        add_notice "Run 'gh auth login' then './install.sh tools' to install the gh-notify extension (powers the snacks.dashboard Notifications section)."
    fi

    # Install shell-color-scripts (provides `colorscript`, used by snacks.dashboard).
    # Upstream Makefile hardcodes /usr/local/bin/colorscript which doesn't exist
    # on Apple Silicon Macs (Homebrew is at /opt/homebrew). Replicate the install
    # ourselves: scripts in /opt/shell-color-scripts (hardcoded in colorscript.sh
    # itself), binary in the brew prefix where the rest of our CLI tools live.
    if ! command -v colorscript &> /dev/null; then
        echo "Installing colorscript..."
        tmpdir="$(mktemp -d)"
        git clone --depth=1 https://gitlab.com/dwt1/shell-color-scripts.git "$tmpdir"
        sudo rm -rf /opt/shell-color-scripts
        sudo mkdir -p /opt/shell-color-scripts/colorscripts
        sudo cp -rf "$tmpdir/colorscripts/"* /opt/shell-color-scripts/colorscripts/
        install -m 755 "$tmpdir/colorscript.sh" "$(brew --prefix)/bin/colorscript"
        rm -rf "$tmpdir"
    else
        echo "colorscript already installed"
    fi

    echo "Additional tools installed!"
}

install_tools

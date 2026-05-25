#!/bin/bash
set -euo pipefail
# Setup git configuration

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

setup_git() {
    echo "Setting up git configuration..."

    local current_git_name=""
    local current_git_email=""
    local keep_current_identity=""
    local git_name=""
    local git_email=""

    current_git_name="$(git config --global --get user.name || true)"
    current_git_email="$(git config --global --get user.email || true)"

    # Copy gitconfig
    cp "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"

    # Prompt for user identity
    if [[ -n "$current_git_name" && -n "$current_git_email" ]]; then
        echo "Current git identity:"
        echo "  Name:  $current_git_name"
        echo "  Email: $current_git_email"
        read -rp "Keep git identity '$current_git_name <$current_git_email>'? [Y/n] " keep_current_identity

        if [[ ! "$keep_current_identity" =~ ^([Nn]|no|NO)$ ]]; then
            git_name="$current_git_name"
            git_email="$current_git_email"
        fi
    fi

    if [[ -z "$git_name" || -z "$git_email" ]]; then
        read -rp "Git user name: " git_name
        read -rp "Git user email: " git_email
    fi

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    # Create global gitignore if it doesn't exist
    if [[ ! -f "$HOME/.gitignore" ]]; then
        cat > "$HOME/.gitignore" << 'EOF'
# OS files
.DS_Store
Thumbs.db

# Editor files
*.swp
*.swo
*~
.idea/
.vscode/
*.sublime-*

# Environment files
.env.local
.env.*.local
EOF
    fi

    echo "Git configuration complete!"
    echo "  Name:  $(git config --global user.name)"
    echo "  Email: $(git config --global user.email)"
}

setup_git

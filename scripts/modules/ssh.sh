#!/bin/bash
set -euo pipefail
# Generate SSH key for GitHub

setup_ssh() {
    echo "Setting up SSH..."

    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
        echo "SSH key already exists, skipping generation"
    else
        read -rp "Email for SSH key: " ssh_email
        ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519"
    fi

    echo ""
    echo "Your public key (add to GitHub → Settings → SSH keys):"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
}

setup_ssh

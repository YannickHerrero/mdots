#!/bin/bash
set -euo pipefail

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"
SOURCE_DIR="$DOTFILES_DIR/config/claude"
TARGET_DIR="$HOME/.claude"

install_claude_config() {
    echo "Installing Claude Code configuration..."

    mkdir -p "$TARGET_DIR/skills"

    cp "$SOURCE_DIR/settings.json" "$TARGET_DIR/settings.json"
    cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    cp "$SOURCE_DIR/statusline.sh" "$TARGET_DIR/statusline.sh"
    chmod +x "$TARGET_DIR/statusline.sh"

    if [[ -d "$SOURCE_DIR/skills" ]]; then
        cp -R "$SOURCE_DIR/skills/." "$TARGET_DIR/skills/"
    fi

    echo "Claude Code configuration installed!"
    echo "  - Settings:  $TARGET_DIR/settings.json"
    echo "  - CLAUDE.md: $TARGET_DIR/CLAUDE.md"
    echo "  - Statusline:$TARGET_DIR/statusline.sh"
    echo "  - Skills:    $TARGET_DIR/skills"
}

install_claude_config

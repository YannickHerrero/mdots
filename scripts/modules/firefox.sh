#!/bin/bash
set -euo pipefail
# Install Firefox + Cozette font, deploy userChrome.css to default profile.

_MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$_MODULE_DIR")")"

MDOTS_USERJS_BEGIN='// >>> mdots-managed: do not edit between markers'
MDOTS_USERJS_END='// <<< mdots-managed'

install_firefox() {
    echo "Installing Firefox..."

    if ! command -v brew &> /dev/null; then
        echo "Error: brew is not installed. Please run brew.sh first."
        exit 1
    fi

    if ! brew list --cask firefox &> /dev/null; then
        if [[ -d /Applications/Firefox.app ]]; then
            # Existing manual install — let brew take over instead of failing.
            brew install --cask --adopt firefox
        else
            brew install --cask firefox
        fi
    else
        echo "Firefox already installed"
    fi

    # CozetteVector is referenced by userChrome.css for tab labels.
    if ! brew list --cask font-cozette &> /dev/null; then
        brew install --cask font-cozette
    else
        echo "Cozette font already installed"
    fi

    # Locate the default profile. Firefox creates this on first launch.
    local profiles_dir="$HOME/Library/Application Support/Firefox/Profiles"
    local profile_dir=""
    if [[ -d "$profiles_dir" ]]; then
        profile_dir=$(find "$profiles_dir" -maxdepth 1 -type d \
            \( -name '*.default-release' -o -name '*.default' \) | head -1)
    fi

    if [[ -z "$profile_dir" ]]; then
        add_notice "Firefox: no profile yet. Launch Firefox once to create one, then run './install.sh firefox' again to deploy userChrome.css."
        return 0
    fi

    echo "Found Firefox profile: $profile_dir"

    # Deploy userChrome.css
    mkdir -p "$profile_dir/chrome"
    cp "$DOTFILES_DIR/config/firefox/userChrome.css" "$profile_dir/chrome/userChrome.css"
    echo "userChrome.css installed in profile chrome/ dir"

    # Enable the legacy customization pref via a marker-guarded block in user.js
    # so we don't clobber any other prefs the user has added.
    local userjs="$profile_dir/user.js"
    if [[ -f "$userjs" ]] && grep -qF "$MDOTS_USERJS_BEGIN" "$userjs"; then
        # Replace existing block
        local tmp
        tmp="$(mktemp)"
        awk -v begin="$MDOTS_USERJS_BEGIN" -v end="$MDOTS_USERJS_END" '
            $0 == begin { skip = 1; next }
            $0 == end   { skip = 0; next }
            !skip       { print }
        ' "$userjs" > "$tmp"
        mv "$tmp" "$userjs"
    fi
    {
        echo "$MDOTS_USERJS_BEGIN"
        echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
        echo "$MDOTS_USERJS_END"
    } >> "$userjs"
    echo "user.js pref set: toolkit.legacyUserProfileCustomizations.stylesheets = true"

    add_notice "Firefox: restart Firefox to load userChrome.css. If styles don't apply, visit about:support and click 'Clear startup cache'."
}

install_firefox

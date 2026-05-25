#!/bin/bash
set -euo pipefail
# Build AutoRaise from source and install a LaunchAgent so macOS focus
# follows the mouse cursor. Complements AeroSpace (which only does
# mouse-follows-focus, not the reverse).

install_autoraise() {
    echo "Installing AutoRaise..."

    if ! command -v brew &> /dev/null; then
        echo "Error: brew is not installed. Please run brew.sh first."
        exit 1
    fi

    local prefix
    prefix="$(brew --prefix)"
    local bin="$prefix/bin/AutoRaise"
    local plist="$HOME/Library/LaunchAgents/com.sbmpost.AutoRaise.plist"

    if [[ -x "$bin" ]]; then
        echo "AutoRaise already installed at $bin (rebuilding to pick up upstream changes)..."
    fi

    # AutoRaise isn't in homebrew. Build from source — small C++ program,
    # compiles in seconds with just Xcode Command Line Tools.
    local tmpdir
    tmpdir="$(mktemp -d)"
    git clone --depth=1 https://github.com/sbmpost/AutoRaise.git "$tmpdir"
    make -C "$tmpdir"
    install -m 755 "$tmpdir/AutoRaise" "$bin"
    rm -rf "$tmpdir"
    echo "AutoRaise binary installed: $bin"

    # LaunchAgent: starts AutoRaise at login and keeps it alive.
    # -delay 1 = 100ms before raising (snappy without being twitchy).
    mkdir -p "$(dirname "$plist")"
    cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.sbmpost.AutoRaise</string>
    <key>ProgramArguments</key>
    <array>
        <string>$bin</string>
        <string>-delay</string>
        <string>1</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF
    echo "LaunchAgent written: $plist"

    # Reload so changes take effect immediately.
    launchctl unload "$plist" 2>/dev/null || true
    launchctl load -w "$plist"
    echo "AutoRaise daemon started."

    add_notice "AutoRaise needs Accessibility permission: System Settings → Privacy & Security → Accessibility → enable AutoRaise. Without it, focus-follows-mouse won't trigger."
}

install_autoraise

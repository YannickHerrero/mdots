# Homebrew on macOS (Apple Silicon: /opt/homebrew, Intel: /usr/local)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
    source "${ZINIT_HOME}/zinit.zsh"

    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zsh-users/zsh-completions
    zinit light zsh-users/zsh-autosuggestions
    zinit light Aloxaf/fzf-tab
fi

autoload -Uz compinit && compinit

if command -v zinit > /dev/null 2>&1; then
    zinit cdreplay -q
fi

# Source configs (ZDOTDIR is set by ~/.zshenv to $XDG_CONFIG_HOME/zsh)
for config in "${ZDOTDIR:-$HOME/.config/zsh}"/*.zsh; do
    source "$config"
done

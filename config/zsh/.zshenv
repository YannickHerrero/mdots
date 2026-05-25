# Tell zsh to read its config from XDG_CONFIG_HOME/zsh instead of $HOME.
# This file lives at ~/.zshenv (sourced before .zshrc on every zsh startup);
# everything else (.zshrc, *.zsh) lives under $ZDOTDIR.
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

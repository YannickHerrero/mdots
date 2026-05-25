# Set git to use personal account in current repository
# Safe to run multiple times - will simply update the config
git-personal() {
	local git_root
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)

	if [[ -z "$git_root" ]]; then
		echo "Error: Not in a git repository"
		return 1
	fi

	git config --local user.name "YannickHerrero"
	git config --local user.email "yannick.herrero@proton.me"

	echo "Git personal account configured for: $(basename "$git_root")"
	echo "  Name:  YannickHerrero"
	echo "  Email: yannick.herrero@proton.me"
}

# Shorter alias for git-personal
alias gsp='git-personal'

if status is-interactive
    # Commands to run in interactive sessions can go here
end

mise activate fish | source
starship init fish | source
zoxide init fish | source

# PNPM config
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

if not contains $PNPM_HOME $PATH
	fish_add_path -g $PNPM_HOME
end

# Yazi config
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end


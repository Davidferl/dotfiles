# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/davidferland/.docker/bin"
# End of Docker Desktop section.

if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path -g $HOME/.local/bin

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


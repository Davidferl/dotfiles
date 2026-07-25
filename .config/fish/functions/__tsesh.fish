function __tsesh --description 'Create-or-switch a 3-window tmux session for a directory'
    set -l dir $argv[1]
    test -z "$dir"; and return 1

    # Session name is the basename of the target directory.
    set -l session (basename $dir)

    # Create the session (claude + nvim + term layout) if it isn't already running.
    if not tmux has-session -t=$session 2>/dev/null
        tmux new-session -d -s $session -c $dir -n claude 'claude --enable-auto-mode'
        tmux new-window -t $session -c $dir -n nvim 'nvim .'
        tmux new-window -t $session -c $dir -n term 'bun i || p i; exec fish'
    end

    # Switch when already inside tmux (e.g. a prefix popup), else attach.
    if set -q TMUX
        tmux switch-client -t $session
    else
        tmux attach -t $session
    end
end

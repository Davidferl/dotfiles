function tsesh
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: not a git repository."
        return 1
    end

    # Fuzzy-pick a worktree; first column of `git worktree list` is the path.
    set -l selected (git worktree list | fzf --height 40% --reverse --prompt 'worktree> ' | awk '{print $1}')
    test -z "$selected"; and return 0

    # Session name is the basename of the worktree path.
    set -l session (basename $selected)

    # Create the session (claude + nvim layout) if it isn't already running.
    if not tmux has-session -t=$session 2>/dev/null
        tmux new-session -d -s $session -c $selected -n claude 'claude --enable-auto-mode'
        tmux new-window -t $session -c $selected -n nvim 'nvim .'
        tmux new-window -t $session -c $selected -n term 'bun i || p i; exec fish'
    end

    # Switch when already inside tmux (e.g. the prefix-f popup), else attach.
    if set -q TMUX
        tmux switch-client -t $session
    else
        tmux attach -t $session
    end
end

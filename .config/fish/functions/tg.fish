function tg --description 'Tmux Git: pick a worktree of the current repo and open a session'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: not a git repository."
        return 1
    end

    # Fuzzy-pick a worktree; first column of `git worktree list` is the path.
    set -l selected (git worktree list | fzf --height 40% --reverse --prompt 'worktree> ' | awk '{print $1}')
    test -z "$selected"; and return 0

    __tsesh $selected
end

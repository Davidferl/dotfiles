function worktc
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: not a git repository."
        return 1
    end

    set -l current (git rev-parse --show-toplevel)
    set -l main (git worktree list --porcelain | awk '/^worktree / {print $2; exit}')

    if test "$current" = "$main"
        echo "Error: not in a worktree."
        return 1
    end

    cd $main
    and git worktree remove $current $argv
end

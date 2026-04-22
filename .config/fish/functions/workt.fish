function workt
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: not a git repository."
        return 1
    end

    set -l branch $argv[1]
    if test -z "$branch"
        echo "Usage: workt <branch-name>"
        return 1
    end

    set -l repo_root (git rev-parse --show-toplevel)
    set -l worktree_dir (dirname $repo_root)/(basename $repo_root)-worktrees/$branch

    git worktree add $worktree_dir $branch 2>/dev/null
    or git worktree add -b $branch $worktree_dir

    and cd $worktree_dir
end

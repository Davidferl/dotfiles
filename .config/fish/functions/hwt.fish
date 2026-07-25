function hwt --description 'herdr worktree: create a worktree + 3-pane layout (claude / nvim / term)'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: not a git repository."
        return 1
    end

    # Pick an existing branch or type a new name. fzf --print-query puts the typed
    # query last when nothing is selected, and the match last when one is picked;
    # either way the final line is the branch we want.
    set -l branches (git for-each-ref --format='%(refname:short)' refs/heads)
    set -l out (printf '%s\n' $branches | fzf --height 40% --reverse --print-query --prompt 'worktree branch> ')
    test (count $out) -eq 0; and return 0
    set -l branch $out[-1]
    test -z "$branch"; and return 0

    # If the branch doesn't exist yet, create it off the current HEAD so herdr only
    # ever has to check out an existing branch (avoids depending on its new-branch semantics).
    if not contains -- $branch $branches
        git branch $branch HEAD; or return 1
    end

    # Create the worktree as a new, focused workspace. Must run from the repo's
    # parent workspace (herdr rejects this from a linked worktree).
    set -l json (herdr worktree create --branch "$branch" --focus --json)
    set -l root (printf '%s' "$json" | python3 -c 'import sys,json; d=json.load(sys.stdin); r=d.get("result"); print(r["root_pane"]["pane_id"] if r else "")')
    if test -z "$root"
        echo "worktree create failed:" >&2
        printf '%s\n' "$json" >&2
        return 1
    end

    # Give the fresh shell a moment before piping commands into it.
    sleep 0.3
    herdr pane run $root "claude --enable-auto-mode"

    # Split right for nvim, then split that down for the term pane.
    set -l nvim (herdr pane split $root --direction right --no-focus --json | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
    sleep 0.2
    herdr pane run $nvim "nvim ."

    set -l term (herdr pane split $nvim --direction down --no-focus --json | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
    sleep 0.2
    herdr pane run $term "bun i || p i"
end

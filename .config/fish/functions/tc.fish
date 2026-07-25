function tc --description 'Tmux Code: pick a project and open a 3-window tmux session'
    # Parent dirs whose immediate children are projects, plus standalone repos.
    # Edit these lists when you add a new project root.
    set -l parents ~/botpress ~/Projects ~/OSS ~/Zed ~/misc
    set -l standalone ~/dotfiles ~/notes

    set -l dirs
    for p in $parents
        test -d $p; and set -a dirs (find $p -mindepth 1 -maxdepth 1 -type d)
    end
    for d in $standalone
        test -d $d; and set -a dirs $d
    end

    # Show paths relative to ~; re-prepend $HOME on the selection.
    set -l selected (printf '%s\n' $dirs | sed "s|^$HOME/||" | sort | fzf --height 40% --reverse --prompt 'code> ')
    test -z "$selected"; and return 0

    __tsesh "$HOME/$selected"
end

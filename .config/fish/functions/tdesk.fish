function tdesk
    set -l session (basename $PWD)

    tmux new-session -d -s $session -n claude 'claude --enable-auto-mode' \; \
        new-window -n nvim 'nvim .' \; \
        new-window -n dev \; send-keys 'bun i && bun dev:ui' Enter \; \
        split-window -h \; \
        attach
end

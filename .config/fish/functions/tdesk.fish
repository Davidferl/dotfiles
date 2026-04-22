function tdesk
    set -l session (basename $PWD)

    tmux new-session -d -s $session -n claude 'claude --enable-auto-mode' \; \
        split-window -h 'claude --enable-auto-mode' \; \
        split-window -h \; \
        select-layout even-horizontal \; \
        new-window -n nvim 'nvim .' \; \
        new-window -n dev \; send-keys 'bun i && bun dev:ui' Enter \; \
        split-window -h \; \
        new-window \; send-keys 'g' Enter \; \
        attach
end

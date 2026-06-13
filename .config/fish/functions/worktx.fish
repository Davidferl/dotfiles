function worktx --argument-names session path
    # Redirect the attached client to the next session before tearing this one down.
    tmux switch-client -n
    tmux kill-session -t $session

    # Remove the worktree this session lived in.
    cd $path
    and worktc --force
end

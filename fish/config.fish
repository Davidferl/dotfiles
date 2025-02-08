if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

source /opt/asdf-vm/asdf.fish
. ~/.asdf/plugins/java/set-java-home.fish

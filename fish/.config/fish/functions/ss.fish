function ss
    if test "$argv[1]" = "gcloud"
        if test "$argv[2]" = "off"
            sed -i '/^\[gcloud\]$/,/^$/s/^disabled = false$/disabled = true/' ~/.config/starship.toml
            echo "Disabled gcloud in ~/.config/starship.toml"
        else if test "$argv[2]" = "on"
            sed -i '/^\[gcloud\]$/,/^$/s/^disabled = true$/disabled = false/' ~/.config/starship.toml
            echo "Enabled gcloud in ~/.config/starship.toml"
        else
            echo "Error: Second argument must be 'on' or 'off'."
        end
    else
        echo "Error: First argument must be 'gcloud'."
    end
end

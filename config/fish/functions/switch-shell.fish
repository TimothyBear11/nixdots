# Fish function to switch Hyprland shells
# Usage: switch-shell <shell-name>
# Examples:
#   switch-shell ambxst
#   switch-shell caelestia
#   switch-shell dms
#   switch-shell noctalia
#   switch-shell next   # cycle to next shell
#   switch-shell prev   # cycle to previous shell

function switch-shell
    set -l conf_dir "$HOME/nixdots/config/hypr"
    set -l conf_file "$conf_dir/hyprland.conf"
    set -l hypr_conf "$HOME/.config/hypr/hyprland.conf"

    # Shell definitions: name, exec command, keybind comment prefix
    set -l shells ambxst caelestia dms noctalia

    # Parse argument
    if test (count $argv) -eq 0
        echo "Usage: switch-shell <shell-name>"
        echo "Available shells: $shells"
        echo "Special: next, prev"
        return 1
    end

    set -l target $argv[1]

    # Handle next/prev
    if test "$target" = "next" -o "$target" = "prev"
        # Find current active shell
        set -l current ""
        for shell in $shells
            if grep -q "exec-once = $shell" $conf_file
                set current $shell
                break
            end
        end

        if test -z "$current"
            set current "ambxst"
        end

        # Find current index
        set -l i 1
        for shell in $shells
            if test "$shell" = "$current"
                break
            end
            set i (math $i + 1)
        end

        if test "$target" = "next"
            set i (math "$i + 1")
            if test $i -gt (count $shells)
                set i 1
            end
        else
            set i (math "$i - 1")
            if test $i -lt 1
                set i (count $shells)
            end
        end

        set target $shells[$i]
    end

    # Validate shell name
    set -l found 0
    for shell in $shells
        if test "$shell" = "$target"
            set found 1
            break
        end
    end

    if test $found -eq 0
        echo "Unknown shell: $target"
        echo "Available: $shells"
        return 1
    end

    echo "Switching to: $target"

    # Read the config file
    set -l content (cat $conf_file)

    # Disable all exec-once lines for shells
    for shell in $shells
        # Match both "exec-once = shell" and "exec-once = shell args"
        set content (string replace -r "#?exec-once = $shell( .*)?" "#exec-once = $shell\$1" $content)
    end

    # Enable the target shell
    set content (string replace "#exec-once = $target" "exec-once = $target" $content)

    # Write back
    echo "$content" > $conf_file

    # Also update Hyprland config symlink
    if test -e $hypr_conf
        cp $conf_file $hypr_conf
    end

    echo "Shell switched to $target. Press Super+Shift+R to restart Hyprland."
end

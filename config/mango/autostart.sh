#!/bin/bash

# --- 1. Environment & Portal Setup ---
# Tells apps they are running in Mango/Wayland
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=mangowc >/dev/null 2>&1
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# --- 2. The Core Shell (DMS) ---
# We launch DMS instead of Waybar/Swaync
dms-shell &


# --- 3. System Services ---
# Polkit for NixOS (Required for apps needing sudo/root permissions)
/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1 &

# Night light
wlsunset -T 3501 -t 3500 &

# Bluetooth & Network Applets
blueman-applet &
nm-applet &

# Clipboard Management
wl-paste --type text --watch cliphist store &
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# --- 5. Tbear's App Layout (Replicating your Hyprland Logic) ---
# We launch these in the background.
# Because we set 'windowrules' in rule.conf, they will jump to the right tags.

sleep 2 && zen &              # Workspace 4
sleep 3 && steam &            # Workspace 2
sleep 3 && heroic &           # Workspace 3
sleep 4 && spotify &          # Workspace 7
sleep 4 && vesktop &          # Workspace 8
sleep 5 && signal-desktop &   # Workspace 9
sleep 5 && kitty -e btop &    # Workspace 5

# --- 6. Input Settings ---
# If you use fcitx5 for different languages, keep this. Otherwise, you can comment it out.
fcitx5 --replace -d &

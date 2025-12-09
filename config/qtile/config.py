import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.backend.wayland import InputConfig

# --- Variables ---
mod = "mod4"
terminal = "kitty"
browser = "brave"

# --- Colors (Matching your Hyprland/Niri theme) ---
colors = {
    "bg": "#1a1a1a",
    "fg": "#ffffff",
    "cyan": "#33ccff",
    "green": "#00ff99",
    "gray": "#595959",
    "dark_gray": "#2a2a2a",
    "urgent": "#ff5555"
}

# --- Autostart ---
@hook.subscribe.startup_once
def autostart():
    # We still run noctalia-shell for the popups/launcher, even if we use Qtile's bar
    processes = [
        ["noctalia-shell"],
        ["swww", "init"],
        ["/usr/bin/sleep", "2", "&&", "steam"],
        ["/usr/bin/sleep", "3", "&&", "heroic"],
        ["vivaldi"],
        ["kitty", "-e", "btop"],
        ["lmstudio"],
        ["vesktop"],
        ["signal-desktop"]
    ]
    for p in processes:
        subprocess.Popen(p, shell=True)

# --- Keybindings ---
keys = [
    # Navigation
    Key([mod], "left", lazy.layout.left()),
    Key([mod], "right", lazy.layout.right()),
    Key([mod], "down", lazy.layout.down()),
    Key([mod], "up", lazy.layout.up()),

    # Movement
    Key([mod, "shift"], "left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up()),

    # Resize (MonadTall)
    Key([mod], "h", lazy.layout.grow()),
    Key([mod], "l", lazy.layout.shrink()),

    # System
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.reload_config()),
    Key([mod, "shift"], "e", lazy.shutdown()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "v", lazy.window.toggle_floating()),

    # Apps
    Key([mod], "e", lazy.spawn("dolphin")),
    Key([mod], "b", lazy.spawn(browser)),
    Key([mod], "k", lazy.spawn("kate")),
    Key([mod], "j", lazy.spawn("joplin-desktop")),

    # Noctalia Integration (Launcher/Settings still work via IPC)
    Key([mod], "d", lazy.spawn("noctalia-shell ipc call launcher toggle")),
    Key([mod], "F1", lazy.spawn("noctalia-shell ipc call controlCenter toggle")),
    Key([mod], "F2", lazy.spawn("noctalia-shell ipc call settings toggle")),
    Key([mod], "F4", lazy.spawn("noctalia-shell ipc call sessionMenu toggle")),
]

# --- Groups ---
groups = [Group(i) for i in "123456789"]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

# --- Layouts ---
layout_theme = {
    "border_width": 2,
    "margin": 7,
    "border_focus": colors["cyan"],
    "border_normal": colors["gray"]
}

layouts = [
    layout.MonadTall(**layout_theme), # Best match for Hyprland Dwindle feel
    layout.Max(),
    layout.Floating(**layout_theme),
]

# --- Bar Configuration ---
# This creates a bar that looks native to your other configs
def init_widgets():
    return [
        widget.TextBox(text="  ", background=colors["bg"]), # Spacer
        widget.GroupBox(
            highlight_method='line',
            this_current_screen_border=colors["cyan"],
            active=colors["green"],
            inactive=colors["gray"],
            background=colors["bg"],
            borderwidth=3
        ),
        widget.TextBox(text="|", foreground=colors["gray"], background=colors["bg"]),
        widget.WindowName(foreground=colors["cyan"], background=colors["bg"]),

        # Right Side Modules
        widget.Systray(background=colors["bg"]),
        widget.Spacer(length=10, background=colors["bg"]),

        widget.CPU(format='CPU {load_percent}%', foreground=colors["green"], background=colors["bg"]),
        widget.TextBox(text="|", foreground=colors["gray"], background=colors["bg"]),

        widget.Memory(format='RAM {MemPercent}%', foreground=colors["cyan"], background=colors["bg"]),
        widget.TextBox(text="|", foreground=colors["gray"], background=colors["bg"]),

        widget.Clock(format='%Y-%m-%d %a %I:%M %p', foreground=colors["fg"], background=colors["bg"]),
        widget.TextBox(text="  ", background=colors["bg"]),
    ]

screens = [
    Screen(
        top=bar.Bar(init_widgets(), 28, background=colors["bg"]),
        # You can add wallpaper here if not using swww
        # wallpaper='~/path/to/wall.png',
        # wallpaper_mode='fill'
    ),
    Screen(top=bar.Bar(init_widgets(), 28, background=colors["bg"])), # Monitor 2
]

# --- Input ---
wl_input_rules = {
    "type:keyboard": InputConfig(kb_layout="us"),
    "type:touchpad": InputConfig(natural_scroll=False),
}

# --- Mouse ---
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

wmname = "LG3D"

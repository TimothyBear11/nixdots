# Qtile Config for Bear
# Based on hyprland/niri keybind patterns

import os
import subprocess
from libqtile import bar, layout, hook, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy

# ==================== VARIABLES ====================
mod = "mod4"           # Super key
terminal = "kitty"     # Default terminal
launcher = "fuzzel"   # Application launcher

# ==================== KEYBINDINGS ====================
keys = [
    # --- Window Navigation ---
    Key([mod], "left", lazy.layout.left()),
    Key([mod], "right", lazy.layout.right()),
    Key([mod], "down", lazy.layout.down()),
    Key([mod], "up", lazy.layout.up()),

    # --- Window Movement ---
    Key([mod, "shift"], "left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up()),

    # --- Window Controls ---
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "v", lazy.window.toggle_floating()),
    Key([mod], "q", lazy.window.kill()),

    # --- Qtile Controls ---
    Key([mod, "shift"], "r", lazy.reload_config()),
    Key([mod, "shift"], "e", lazy.shutdown()),

    # --- Launcher ---
    Key([mod], "d", lazy.spawn(launcher)),

    # --- Applications ---
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "n", lazy.spawn(f"{terminal} -e nvim")),
    Key([mod], "k", lazy.spawn("kate")),
    Key([mod], "z", lazy.spawn("zeditor")),
    Key([mod], "b", lazy.spawn("floorp")),
    Key([mod], "m", lazy.spawn("spotify")),
    Key([mod], "v", lazy.spawn("vesktop")),
    Key([mod], "g", lazy.spawn("steam")),
    Key([mod], "h", lazy.spawn("heroic")),
    Key([mod], "e", lazy.spawn("dolphin")),
    Key([mod], "j", lazy.spawn("joplin-desktop")),
    Key([mod], "p", lazy.spawn("positron")),
    Key([mod], "s", lazy.spawn("signal-desktop")),

    # --- Scratchpad ---
    Key([mod], "grave", lazy.group['scratchpad'].dropdown_toggle('term')),
]

# ==================== WORKSPACES ====================
groups = [Group(str(i)) for i in range(1, 10)]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod, "control"], i.name, lazy.window.togroup(i.name)),
    ])

# ==================== SCRATCHPAD ====================
groups.append(
    ScratchPad("scratchpad", [
        DropDown(
            "term", 
            "kitty --class=scratchpad",
            opacity=0.95,
            height=0.6,
            width=0.8,
            x=0.1,
            y=0.2,
        )
    ])
)

# ==================== LAYOUTS ====================
layouts = [
    layout.Columns(
        border_focus="#ffc87f",
        border_normal="#505050",
        border_width=2,
        margin=8,
        insert_position=1,
    ),
    layout.Max(),
    layout.Floating(),
]

# ==================== BAR WIDGETS ====================
def init_widgets_left():
    return [
        widget.CPU(format="CPU: {load_percent}%"),
        widget.Memory(format="RAM: {MemUsed: .0f}{mm}"),
        widget.GroupBox(),
        widget.CurrentLayout(),
    ]

def init_widgets_center():
    return [
        widget.Clock(format="%H:%M"),
        widget.Clock(format="%a %b %d"),
    ]

def init_widgets_right():
    return [
        widget.Systray(),
        widget.Notifications(),
    ]

# ==================== SCREENS ====================
screens = [
    Screen(
        top=bar.Bar(
            widgets=init_widgets_left() + init_widgets_center() + init_widgets_right(),
            size=30,
            opacity=0.9,
            margin=[4, 8, 0, 8],
        )
    )
]

# ==================== MOUSE BINDINGS ====================
mouse = [
    Drag([mod], "left", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "right", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "button1", lazy.window.bring_to_front()),
]

# ==================== FLOATING RULES ====================
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="fuzzel"),
        Match(wm_class="noctalia-shell"),
        Match(wm_class="Noctalia-shell"),
        Match(wm_class="dms"),
        Match(wm_class="scratchpad"),
    ]
)

# ==================== AUTOSTART ====================
@hook.subscribe.startup_once
def autostart():
    # Wallpaper
    subprocess.Popen(["swww", "img", os.path.expanduser("~/nixdots/Pictures/Wallpapers/Runic.png")])
    # Daemons
    subprocess.Popen(["kanshi"])
    subprocess.Popen(["swww-daemon"])

# ==================== BEHAVIOR SETTINGS ====================
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
focus_on_window_activation = "smart"
auto_minimize = True
reconfigure_screens = True
wmname = "Qtile"

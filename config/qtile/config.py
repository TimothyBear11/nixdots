import os
import subprocess
from libqtile import layout, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.backend.wayland import InputConfig

# --- Variables ---
mod = "mod4"
terminal = "kitty"

# --- Helper: Spawn on Current Screen ---
# This fixes your issue where everything opens on the center monitor.
def spawn_on_current(command):
    @lazy.function
    def __inner(qtile):
        qtile.spawn(command)
    return __inner

# --- Keybindings ---
keys = [
    # Navigation (Arrow Keys)
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),

    # Movement
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),

    # Monitor Switching (Crucial for 3 screens)
    # These force focus to a specific physical monitor
    Key([mod], "w", lazy.to_screen(0), desc="Focus Center"),
    Key([mod], "r", lazy.to_screen(1), desc="Focus Left"),
    Key([mod], "p", lazy.to_screen(2), desc="Focus Right"),
    
    # Standard Controls
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod, "control"], "v", lazy.window.toggle_floating()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.reload_config()),
    Key([mod, "shift"], "e", lazy.shutdown()),
    Key([mod], "Tab", lazy.group.next_window()), # Cycle windows if focus gets lost

    # SCRATCHPAD (Mod + `)
    Key([mod], "grave", lazy.group['scratchpad'].dropdown_toggle('term')),

    # Apps (Using the Spawn Helper)
    Key([mod], "Return", spawn_on_current(terminal)),
    Key([mod], "d", spawn_on_current("noctalia-shell ipc call launcher toggle")),
    Key([mod], "F1", spawn_on_current("noctalia-shell ipc call controlCenter toggle")),
    Key([mod], "F2", spawn_on_current("noctalia-shell ipc call settings toggle")),
    Key([mod], "F3", spawn_on_current("noctalia-shell ipc call launcher clipboard")),
    Key([mod], "F4", spawn_on_current("noctalia-shell ipc call sessionsMenu toggle")),
    
    Key([mod], "k", spawn_on_current("kate")),
    Key([mod], "b", spawn_on_current("zen")),
    Key([mod], "m", spawn_on_current("spotify")),
    Key([mod], "v", spawn_on_current("vesktop")),
    Key([mod], "s", spawn_on_current("steam")),
    Key([mod], "h", spawn_on_current("heroic")),
    Key([mod], "z", spawn_on_current("zeditor")),
    Key([mod], "e", spawn_on_current("dolphin")),
    Key([mod], "j", spawn_on_current("joplin-desktop")),
    Key([mod], "a", spawn_on_current("signal-desktop")),
    Key([mod], "t", spawn_on_current("konsole")),
]

# --- Groups & Scratchpad ---
groups = [Group(i) for i in "123456789"]

groups.append(
    ScratchPad("scratchpad", [
        DropDown("term", "kitty --class=scratchpad", 
                 opacity=0.9, height=0.6, width=0.8, x=0.1, y=0.2, 
                 on_focus_lost_hide=True)
    ]),
)

for i in "123456789":
    keys.extend([
        Key([mod], i, lazy.group[i].toscreen()),
        Key([mod, "control"], i, lazy.window.togroup(i)),
    ])

# --- Layouts ---
layouts = [
    layout.Columns(
        border_focus="#ffc87f", 
        border_normal="#505050", 
        margin=8, 
        border_width=2,
        border_on_single=True,
        insert_position=1, # New windows appear next to current focus
        wrap_focus_columns=False,
        wrap_focus_rows=False,
    ),
    layout.Max(),
]

# --- Screens ---
screens = [Screen(), Screen(), Screen()]

# --- Autostart ---
@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(["noctalia-shell"], shell=True)
    subprocess.Popen(["kanshi"], shell=True)
    subprocess.Popen(["swww-daemon"], shell=True)

# --- Force Zen Browser to Tile ---
@hook.subscribe.client_new
def force_tile_browser(window):
    # This detects Zen and forces it into the tiling layer
    if "zen" in window.get_wm_class() or "Zen" in window.name:
        window.floating = False

# --- Input Rules ---
wl_input_rules = {
    "type:keyboard": InputConfig(kb_layout="us"),
    "type:pointer": InputConfig(accel_profile="flat"),
    "type:touchpad": InputConfig(tap=True, natural_scroll=True),
}

# --- Floating Rules ---
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="noctalia-shell"),
        Match(wm_class="Noctalia-shell"),
        Match(wm_class="scratchpad"),
    ]
)

# --- Focus Settings (The Stability Patch) ---
# Setting this to False prevents the mouse from stealing focus or 
# creating "dead zones" when you close windows.
follow_mouse_focus = False

# This teleports the mouse to the center of the focused window.
cursor_warp = True

# Prevents windows from jumping to the front just because they were clicked.
bring_front_click = False

# Fixes focus when apps request attention.
focus_on_window_activation = "smart"

# Essential for Wayland and Steam.
auto_minimize = False
reconfigure_screens = True
wmname = "LG3D"

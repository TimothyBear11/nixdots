import os
import json
import subprocess
from libqtile import bar, layout, hook, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from qtile_extras import widget as ext_widget
from qtile_extras.widget.decorations import RectDecoration

# ==================== THEME LOADING ====================
def load_colors():
    colors_path = os.path.expanduser("~/nixdots/config/noctalia/colors.json")
    try:
        with open(colors_path, "r") as f:
            colors = json.load(f)
            # Ensure required keys exist with fallbacks
            defaults = {
                "mPrimary": "#ff4d4d",
                "mSurface": "#151a1c",
                "mOnSurface": "#e1e8e6",
                "mSecondary": "#2a5a5c",
                "mTertiary": "#56b6c2",
                "mOnPrimary": "#151a1c",
                "mSurfaceVariant": "#0b3335"
            }
            for key, val in defaults.items():
                if key not in colors:
                    colors[key] = val
            return colors
    except Exception:
        return {
            "mPrimary": "#ff4d4d",
            "mSurface": "#151a1c",
            "mOnSurface": "#e1e8e6",
            "mSecondary": "#2a5a5c",
            "mTertiary": "#56b6c2",
            "mOnPrimary": "#151a1c",
            "mSurfaceVariant": "#0b3335"
        }

c = load_colors()

# ==================== VARIABLES ====================
mod = "mod4"           # Super key
terminal = "kitty"     # Default terminal
launcher = "fuzzel"    # Application launcher

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
    Key([mod, "shift"], "v", lazy.spawn("vesktop")),
    Key([mod], "g", lazy.spawn("steam")),
    Key([mod], "h", lazy.spawn("heroic")),
    Key([mod], "e", lazy.spawn("dolphin")),
    Key([mod], "j", lazy.spawn("joplin-desktop")),
    Key([mod], "p", lazy.spawn("positron")),
    Key([mod], "s", lazy.spawn("signal-desktop")),

    # --- Shell Switching (Playground consistency) ---
    Key([mod, "mod1"], "a", lazy.spawn(os.path.expanduser("~/nixdots/scripts/shell-switch ambxst"))),
    Key([mod, "mod1"], "c", lazy.spawn(os.path.expanduser("~/nixdots/scripts/shell-switch caelestia"))),
    Key([mod, "mod1"], "d", lazy.spawn(os.path.expanduser("~/nixdots/scripts/shell-switch dms"))),
    Key([mod, "mod1"], "n", lazy.spawn(os.path.expanduser("~/nixdots/scripts/shell-switch noctalia"))),
    Key([mod, "mod1"], "e", lazy.spawn(os.path.expanduser("~/nixdots/scripts/shell-switch end4"))),

    # --- Scratchpad ---
    Key([mod], "grave", lazy.group['scratchpad'].dropdown_toggle('term')),

    # --- Hardware Controls ---
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
]

# ==================== WORKSPACES ====================
# Mapping groups to monitors (3 per monitor as requested)
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
layout_theme = {
    "border_focus": c["mPrimary"],
    "border_normal": c["mSurface"],
    "border_width": 2,
    "margin": 10,
}

layouts = [
    layout.Columns(**layout_theme, insert_position=1),
    layout.MonadTall(**layout_theme),
    layout.Spiral(**layout_theme),
    layout.Max(),
    layout.Floating(),
]

# ==================== BAR DECORATIONS ====================
def get_pill_decor(color, padding=10):
    return [
        RectDecoration(
            colour=color,
            radius=12,
            filled=True,
            padding_y=4,
            padding_x=padding,
            group=True,
        )
    ]

# ==================== BAR WIDGETS ====================
def init_widgets(is_primary=True):
    widgets = [
        widget.Spacer(length=10),
        
        # Logo / Menu
        ext_widget.TextBox(
            text="󱄅",
            fontsize=20,
            foreground=c["mPrimary"],
            mouse_callbacks={"Button1": lazy.spawn(launcher)},
            padding=10,
        ),

        widget.Spacer(length=5),

        # Workspaces
        widget.GroupBox(
            highlight_method="block",
            rounded=True,
            this_current_screen_border=c["mPrimary"],
            active=c["mOnSurface"],
            inactive=c["mSurfaceVariant"],
            background=c["mSurface"],
            padding_x=10,
            decorations=get_pill_decor(c["mSurface"], padding=0),
        ),

        widget.Spacer(length=10),

        # Window Name
        widget.WindowName(
            foreground=c["mTertiary"],
            format="{name}",
            max_chars=40,
        ),

        widget.Spacer(length=bar.STRETCH),

        # Clock Pill
        widget.Clock(
            format="󱑎 %H:%M",
            foreground=c["mOnPrimary"],
            decorations=get_pill_decor(c["mPrimary"]),
        ),
        
        widget.Spacer(length=10),

        widget.Clock(
            format="󰃭 %a %d",
            foreground=c["mOnSurface"],
            decorations=get_pill_decor(c["mSurface"]),
        ),

        widget.Spacer(length=bar.STRETCH),

        # Hardware Info
        ext_widget.PulseVolume(
            fmt="󰕾 {}",
            foreground=c["mOnSurface"],
            decorations=get_pill_decor(c["mSecondary"]),
            limit_max_volume=True,
        ),

        widget.Spacer(length=10),

        ext_widget.Memory(
            format="󰍛 {MemUsed: .0f}{mm}",
            foreground=c["mOnSurface"],
            decorations=get_pill_decor(c["mSurfaceVariant"]),
        ),
    ]
    
    if is_primary:
        widgets.extend([
            widget.Spacer(length=10),
            widget.StatusNotifier(),
        ])
    
    # Power Button
    widgets.extend([
        widget.Spacer(length=10),
        ext_widget.TextBox(
            text="󰐥",
            fontsize=18,
            foreground="#ff4d4d",
            mouse_callbacks={"Button1": lazy.spawn(os.path.expanduser("~/nixdots/scripts/shell-switch noctalia"))}, 
            padding=10,
        ),
        widget.Spacer(length=10),
    ])
    
    return widgets

# ==================== SCREENS ====================
def init_screens():
    # Detect monitors using xrandr/wlr-randr equivalent logic or just assume 3
    # For a Wayland playground, we often have multiple screens.
    # We'll create 3 screens to match your Hyprland setup.
    return [
        Screen(top=bar.Bar(widgets=init_widgets(True), size=34, background="#00000000", margin=[5, 10, 0, 10])),
        Screen(top=bar.Bar(widgets=init_widgets(False), size=34, background="#00000000", margin=[5, 10, 0, 10])),
        Screen(top=bar.Bar(widgets=init_widgets(False), size=34, background="#00000000", margin=[5, 10, 0, 10])),
    ]

screens = init_screens()

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
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)

# ==================== AUTOSTART ====================
@hook.subscribe.startup_once
def autostart():
    # Wallpaper & Daemons
    subprocess.Popen(["swww-daemon"])
    subprocess.Popen(["swww", "img", os.path.expanduser("~/nixdots/Pictures/Wallpapers/Runic.png")])
    subprocess.Popen(["kanshi"])

# ==================== BEHAVIOR SETTINGS ====================
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
focus_on_window_activation = "smart"
auto_minimize = True
reconfigure_screens = True
wmname = "Qtile"


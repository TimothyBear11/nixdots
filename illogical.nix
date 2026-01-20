{ pkgs, ... }:

{
  xdg.enable = true;

  programs.illogical-impulse = {
    enable = true;
    dotfiles = {
      fish.enable = true;
      kitty.enable = true;
      starship.enable = true;
    };
    # Plugins are still commented out to avoid the version mismatch error from before
    # hyprland.plugins = [ ... ]; 
  };

  # End4's dots automatically "source" files from ~/.config/hypr/custom/
  # We will use xdg.configFile to create those files with your settings.

  # 1. Monitors and Workspace Rules
  xdg.configFile."hypr/custom/general.conf".text = ''
    monitor = DP-1, preferred, auto, auto
    monitor = DP-2, preferred, auto-left, auto
    monitor = HDMI-A-1, preferred, auto-right, auto

    workspace = 1, monitor:DP-1, persistent:true
    workspace = 2, monitor:DP-1, persistent:true
    workspace = 3, monitor:DP-1, persistent:true
    workspace = 4, monitor:DP-2, persistent:true
    workspace = 5, monitor:DP-2, persistent:true
    workspace = 6, monitor:DP-2, persistent:true
    workspace = 7, monitor:HDMI-A-1, persistent:true
    workspace = 8, monitor:HDMI-A-1, persistent:true
    workspace = 9, monitor:HDMI-A-1, persistent:true
  '';

  # 2. Autostarts (Execs)
  xdg.configFile."hypr/custom/execs.conf".text = ''
    exec-once = [workspace 2] sleep 5 && steam
    exec-once = [workspace 3] sleep 5 && heroic
    exec-once = [workspace 4] zen
    exec-once = [workspace 5] kitty -e btop
    exec-once = [workspace 6] lm-studio
    exec-once = [workspace 7] sleep 2 && spotify
    exec-once = [workspace 8] sleep 2 && vesktop
    exec-once = [workspace 9] signal-desktop
  '';

  # 3. Keybinds
  xdg.configFile."hypr/custom/keybinds.conf".text = ''
    $mainMod = SUPER

    bind = $mainMod, Return, exec, kitty
    bind = $mainMod, E, exec, dolphin
    bind = $mainMod, B, exec, zen
    bind = $mainMod, Z, exec, zeditor
    bind = $mainMod, C, exec, codium
    bind = $mainMod, N, exec, kitty -e nvim
    bind = $mainMod, K, exec, kate
    bind = $mainMod, J, exec, joplin-desktop

    # Workspace management
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Volume/Media
    bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPause, exec, playerctl play-pause
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioPrev, exec, playerctl previous
  '';
}

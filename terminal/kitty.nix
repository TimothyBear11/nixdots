{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      # ==========================================
      # Window Layout & Behavior
      # ==========================================
      scrollback_lines = 10000;
      window_padding_width = 12;
      hide_window_decorations = "yes";
      background_opacity = "0.9";
      confirm_os_window_close = 0;

      # Layouts
      enabled_layouts = "splits,stack,tall";

      # ==========================================
      # Functionality & Mouse
      # ==========================================
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
      mouse_hide_wait = "3.0";

      # Cursor Trail Animation
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;

      # Advanced / Shell
      shell = "fish";

      # ==========================================
      # Color Scheme & Cursor (Marchborn Guardian)
      # ==========================================
      background = "#151A1C";
      foreground = "#E1E8E6";
      selection_background = "#2A5A5C";
      selection_foreground = "#E1E8E6";

      cursor = "#FF4D4D";
      cursor_text_color = "#151A1C";
      cursor_shape = "block";
      cursor_blink_interval = "0.5";

      url_color = "#4DB8FF";

      # The 16 terminal colors
      color0 = "#151A1C";
      color8 = "#2A5A5C";
      color1 = "#FF4D4D";
      color9 = "#FF7373";
      color2 = "#2A5A5C";
      color10 = "#4DB8FF";
      color3 = "#E5C07B";
      color11 = "#E5D09B";
      color4 = "#4DB8FF";
      color12 = "#73C6FF";
      color5 = "#C678DD";
      color13 = "#D698ED";
      color6 = "#56B6C2";
      color14 = "#76C6D2";
      color7 = "#E1E8E6";
      color15 = "#FFFFFF";
    };

    keybindings = {
      "alt+left" = "neighboring_window left";
      "alt+right" = "neighboring_window right";
      "alt+up" = "neighboring_window up";
      "alt+down" = "neighboring_window down";
      "f1" = "toggle_layout stack";

      # Optional: quick split
      "ctrl+alt+enter" = "launch --cwd=current";
      "ctrl+shift+enter" = "launch --cwd=current";
      "ctrl+shift+h" = "split_window horizontal";
      "ctrl+shift+v" = "split_window vertical";
    };

    # Scrollback pager & Mouse Maps
    extraConfig = ''
      # Open scrollback in nvim directly
      scrollback_pager nvim -c "set signcolumn=no showtabline=0" -c "autocmd TermOpen * startinsert" -c "terminal"

      # Middle click to paste from selection (standard Linux behavior)
      mouse_map middle release ungrabbed paste_from_selection
    '';
  };
}

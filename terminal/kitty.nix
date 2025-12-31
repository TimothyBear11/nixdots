{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # Font selection (Nerd Font recommended for icons in Starship / eza / git)
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    # Settings improvements
    settings = {
      scrollback_lines = 10000;          # good
      window_padding_width = 10;         # good
      allow_remote_control = "yes";      # needed for scripts
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";

      background_opacity = "0.9";        # semi-transparent
      hide_window_decorations = "yes";
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";

      # Layouts
      enabled_layouts = "splits,stack,tall";

      # Suggested: enable ligatures for Nerd Fonts
      enable_ligatures = true;

      # Suggested: smooth scrolling
      smooth_scrolling = true;
    };

    keybindings = {
      "alt+left" = "neighboring_window left";
      "alt+right" = "neighboring_window right";
      "alt+up" = "neighboring_window up";
      "alt+down" = "neighboring_window down";
      "f1" = "toggle_layout stack";
      "ctrl+alt+enter" = "launch --cwd=current";

      # Optional: quick split
      "ctrl+shift+enter" = "launch --cwd=current";
      "ctrl+shift+h" = "split_window horizontal";
      "ctrl+shift+v" = "split_window vertical";
    };

    # Scrollback pager improvement
    extraConfig = ''
      # Open scrollback in nvim directly
      scrollback_pager nvim -c "set signcolumn=no showtabline=0" -c "autocmd TermOpen * startinsert" -c "terminal"
    '';
  };
}

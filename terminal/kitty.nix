programs.kitty = {
  enable = true;

  # 1. Fonts: Home Manager handles the font package and the config
  font = {
    name = "Fira Code"; # or "JetBrains Mono"
    size = 12;
  };

  # 2. Themes: Don't manual-copy! Nix can pull from the kitty-themes repo.
  # Options: "Tokyo Night", "Catppuccin-Mocha", "Gruvbox Dark", etc.
  themeFile = "Catppuccin-Mocha";

  # 3. Standard Settings (the key-value pairs from kitty.conf)
  settings = {
    scrollback_lines = 10000;
    window_padding_width = 10;
    allow_remote_control = "yes"; # Useful for scripts
    listen_on = "unix:/tmp/kitty";
    shell_integration = "enabled";

    # Modern Aesthetics
    background_opacity = "0.9";
    hide_window_decorations = "yes";
    cursor_trail = 3;
    cursor_trail_decay = "0.1 0.4";

    # Layouts
    enabled_layouts = "splits,stack,tall";
  };

  # 4. Keybindings: Nix makes these very readable
  keybindings = {
    "alt+left" = "neighboring_window left";
    "alt+right" = "neighboring_window right";
    "alt+up" = "neighboring_window up";
    "alt+down" = "neighboring_window down";
    "f1" = "toggle_layout stack";
    "ctrl+alt+enter" = "launch --cwd=current";
  };

  # 5. Advanced: Custom scrollback pager (opens history in Neovim)
  extraConfig = ''
    scrollback_pager nvim -c "set signcolumn=no showtabline=0" -c "autocmd TermOpen * startinsert" -c "terminal"
  '';
};

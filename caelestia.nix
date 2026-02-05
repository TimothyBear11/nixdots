{ pkgs, inputs, ... }:

{

imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

programs.caelestia = {
  enable = true;
  systemd = {
    enable = false; # if you prefer starting from your compositor
    target = "graphical-session.target";
    environment = [];
  };

  settings = {

    visualizer = {
      enable = true;
    };

    # 2. Desktop Clock Settings
    widgets = {
      desktop = {
        clock = {
          enable = true;
          position = "top-right"; # Options: top-left, top-center, top-right, etc.
        };
      };
    };

    bar.status = {
      showBattery = false;
    };
    paths.wallpaperDir = "~/nixdots/Pictures/Wallpapers";
  };
  cli = {
    enable = true; # Also add caelestia-cli to path
    settings = {
      theme.enableGtk = true;
    };
  };
};

}

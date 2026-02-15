{ pkgs, inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    package = inputs.caelestia-shell.packages.${pkgs.system}.default;

    systemd.enable = false; 

    settings = {
      # Use 'visualiser' with an 's'
      background = {
        visualiser = {
          enabled = true;
          scale = 1.0;
          rounding = 4;
        };

        desktopClock = {
          enabled = true;
          position = "top-right";
          scale = 1.0;
          autoHide = false;
          rounding = 0;
          spacing = 8;
        };
      };

      # Fix the wallpaper path to be absolute just in case
      path.wallpaperDir = "/home/tbear/nixdots/Pictures/Wallpapers"; 

      font.family.clock = "Rubik";
      anim.durations.scale = 1.0;

      bar.workspaces = {
        shown = 3;
        activeIndicator = true;
        activeTrail = false;
        perMonitorWorkspaces = true;
        showWindows = true;
      };
    };

    cli.enable = true;
  };
}

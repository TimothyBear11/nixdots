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

      paths.wallpaperDir = "~/nixdots/Pictures/Wallpapers"; 

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
    # cli.schemeCommand = false;  # Disable scheme command if it causes issues
  };

  # Skip python deps for now - the scheme command may need manual pip install
  # home.packages = with pkgs; [
  #   (python313.withPackages (ps: with ps; [
  #     materialyoucolor
  #   ]))
  # ];
}

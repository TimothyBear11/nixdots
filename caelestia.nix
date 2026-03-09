{ pkgs, inputs, ... }:

{
  # Explicitly import the Caelestia Home Manager module
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = false; 

    settings = {
      scheme = {
        name = "dynamic";
        source = "/home/tbear/nixdots/Pictures/tbearlogo.png";
      };

      font.family.clock = "Acme"; 

      background = {
        visualiser.enabled = true;
        desktopClock = {
          enabled = true;
          position = "top-right";
        };
      };

      paths.wallpaperDir = "~/nixdots/Pictures/Wallpapers"; 
    };
    
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}

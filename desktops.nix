{ config, pkgs, ... }:

{

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  
  
  environment.systemPackages = [ 
    pkgs.xwayland-satellite
    pkgs.dms-shell
    pkgs.noctalia-shell
    ];

  }

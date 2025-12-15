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

  programs.mango = {
    enable = true;
  };

  environment.systemPackages = [ pkgs.xwayland-satellite ];
}

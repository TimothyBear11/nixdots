{ config, pkgs, lib, ... }:

{
  # --- 1. System Level (Keep these here) ---
  services.xserver.enable = true;
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [ qtile-extras ];
  };

  # Make sure the package is installed globally so config.py can find it
  environment.systemPackages = [ pkgs.kanshi ];

  # --- 2. Home Manager Level (Move Kanshi here) ---
  # Assuming your username is "tbear" based on your previous logs
  home-manager.users.tbear = {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "triple-monitor";
          profile.outputs = [
            { criteria = "DP-2"; position = "0,0"; }
            { criteria = "DP-1"; position = "1920,0"; }
            { criteria = "HDMI-A-1"; position = "4480,0"; }
          ];
        }
      ];
    };


  };
}

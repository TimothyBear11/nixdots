{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Adds a "Steam (Gamescope)" entry to login manager
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    protonup-qt
    lutris
  ];
}

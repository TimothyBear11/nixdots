{ config, pkgs, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Adds a "Steam (Gamescope)" entry to login manager
  };

  # Enable Gamescope (The Compositor)
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Allow gamescope to prioritize itself (smoother performance)
  };



  environment.systemPackages = with pkgs; [
    heroic
    protonup-qt # GUI for managing Proton GE versions
    lutris
  ];
}

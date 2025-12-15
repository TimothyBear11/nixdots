{ config, pkgs, ... }:

{

  programs.mangohud = {
    enable = true;
    settings = {
      full = true;
      limit_fps = 144;
    };
  };

  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kate
    vivaldi
    signal-desktop
    filezilla
    spotify
    vesktop
    joplin-desktop
    pcmanfm
    pywalfox-native
    spicetify-cli
  ];
}

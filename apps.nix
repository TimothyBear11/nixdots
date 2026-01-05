{ config, pkgs, ... }:

{
  # ... (mangohud config) ...

  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kate
    vivaldi
    signal-desktop
    filezilla
    spotify
    legcord
   # vesktop-bin
    joplin-desktop
    pcmanfm
    pywalfox-native
    spicetify-cli
  ];
}

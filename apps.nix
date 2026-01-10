{ config, pkgs, ... }:

{
  # ... (mangohud config) ...

  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kate
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

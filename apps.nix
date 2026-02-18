{ config, pkgs, ... }:

{
  # ... (mangohud config) ...

  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kate
    signal-desktop
    filezilla
    vesktop
    joplin-desktop
    pcmanfm
    pywalfox-native
    spicetify-cli
    uv
    jq
    apostrophe 
    obsidian
    ani-cli
    mpv
    yt-dlp
    ffmpeg
    ffmpegthumbnailer
    floorp-bin
    telegram-desktop
  ];
}

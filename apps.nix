{ config, pkgs, ... }:

{
  # ... (mangohud config) ...

  home.packages = with pkgs; [
    thunar
    thunar-volman
    thunar-vcs-plugin
    thunar-media-tags-plugin
    tumbler
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
    wtfutil
    superfile
  ];
}

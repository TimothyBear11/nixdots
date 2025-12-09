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

    vivaldi
    signal-desktop
    filezilla
    spotify
    vesktop
    zed-editor
    joplin-desktop
    pcmanfm
    go
  ];
}
